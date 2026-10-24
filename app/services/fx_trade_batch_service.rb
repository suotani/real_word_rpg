# 3戦略(FxStrategies::NyRolloverDip/GotoBiFixing/DipBounce)のバッチ本体。
# cron(Render cronサービス)から1分ごとにHTTP経由で呼ばれる想定で、「1回呼ばれたら
# 各戦略について今の状態を見て1つだけ判断する」ワンショットの作りになっている
# (プロセスを常駐させずcronの1回1回が独立して安全に動くように設計してある)。
#
# 保有状態の判定はGMOの建玉照会(口座全体の集計値)ではなく、このアプリ自身の
# FxTradeLog(当日のentryログがcloseログと対になっていないか)を基準にする。
# GMOコインは同一銘柄での両建て(反対方向の同時保有)ができない前提のため、各戦略の
# 判断はこのアプリのレジャーだけで独立に行い、実際の発注直前にGMOの建玉を確認して
# 期待とズレていれば発注せずエラーとして記録する(ズレたまま発注すると、意図と逆方向の
# 注文になり実際の口座に予期しない建玉を作ってしまう恐れがあるため)。
#
# 実行順序: 1回のバッチ呼び出しの中で「全戦略の決済判断」→「全戦略のエントリー判断」の
# 2段階に分けて処理する。これにより、優先度の低い戦略(③)が優先度の高い戦略(①②)の
# 稼働時間帯への明け渡しで決済する場合、同じ分の中で①②のエントリーより先に決済が
# 完了し、両建て不可による誤発注を避けられる。
#
# 二重発注防止: エントリー/決済のたびに FxTradeLog へ「予約」を1行作成してから
# 実際にGMO APIへ発注する。DBの一意制約(戦略ごとに1日1回まで)が先に通った場合だけ
# 発注するので、cronが同じ分に重複して呼ばれても二重発注にならない。発注自体が失敗した
# 場合は予約行を削除し、次回のcron呼び出しで再試行できるようにする。
class FxTradeBatchService
  STRATEGIES = [
    FxStrategies::NyRolloverDip,
    FxStrategies::GotoBiFixing,
    FxStrategies::DipBounce
  ].freeze

  def run
    now = Time.current
    results = {}
    STRATEGIES.each { |s| results[s::KEY] = run_exit_phase(s, now) }
    STRATEGIES.each { |s| results[s::KEY] ||= run_entry_phase(s, now) }
    results
  end

  private

  def run_exit_phase(strategy, now)
    with_error_handling(strategy) do
      setting = FxBotSetting.for(strategy::KEY)
      if setting.enabled
        entry = FxTradeLog.open_entry(strategy::KEY)
        entry && handle_open_position(strategy, setting, now, entry)
      else
        { skipped: true, reason: 'disabled' }
      end
    end
  end

  def run_entry_phase(strategy, now)
    with_error_handling(strategy) do
      setting = FxBotSetting.for(strategy::KEY)
      if setting.enabled
        entry = FxTradeLog.open_entry(strategy::KEY)
        entry ? nil : handle_no_position(strategy, setting, now)
      end
    end
  end

  def with_error_handling(strategy)
    yield
  rescue StandardError => e
    FxTradeLog.create!(trade_date: Date.current, strategy: strategy::KEY, event: 'error',
                        note: "#{e.class}: #{e.message}")
    { error: e.message }
  end

  # --- 決済判断 ---

  def handle_open_position(strategy, setting, now, entry)
    if strategy == FxStrategies::DipBounce
      check_dip_bounce_exit(setting, now, entry)
    else
      check_fixed_time_exit(strategy, setting, now, entry)
    end
  end

  def check_fixed_time_exit(strategy, setting, now, entry)
    entry = ensure_entry_price(entry)
    current_price = GmoCoinApi.get_price
    stop_hit = entry.price && current_price && current_price >= entry.price.to_f + setting.stop_loss_yen
    time_hit = strategy.time_exit?(now)
    return { noop: true, reason: 'holding' } unless stop_hit || time_hit

    close_position(strategy, setting, stop_hit ? 'stop_loss' : 'time_exit')
  end

  def check_dip_bounce_exit(setting, now, entry)
    day_open = dip_bounce_day_open
    current_price = GmoCoinApi.get_price
    stop_hit = day_open && current_price &&
               FxStrategies::DipBounce.stop_loss_hit?(day_open, current_price, setting.stop_loss_yen)
    timeout_hit = FxStrategies::DipBounce.timeout?(now, entry.created_at)
    handoff_hit = FxStrategies::DipBounce.forced_handoff?(now)
    return { noop: true, reason: 'holding' } unless stop_hit || timeout_hit || handoff_hit

    reason = stop_hit ? 'stop_loss' : (handoff_hit ? 'handoff' : 'time_exit')
    close_position(FxStrategies::DipBounce, setting, reason)
  end

  def close_position(strategy, setting, reason)
    claim = claim_once(strategy: strategy::KEY, event: 'close', reason:)
    return { skipped: true, reason: 'already_closed' } unless claim

    begin
      position, = GmoCoinApi.get_position
      raise "no open position at broker to close (expected #{strategy::ENTRY_SIDE})" unless position

      send_order(opposite_side(strategy::ENTRY_SIDE), setting.size)
    rescue StandardError
      claim.destroy
      raise
    end

    margin = GmoCoinApi.get_margin
    claim.update!(margin:) if margin
    { closed: true, reason:, margin: }
  end

  # --- エントリー判断 ---

  def handle_no_position(strategy, setting, now)
    if strategy == FxStrategies::DipBounce
      check_dip_bounce_entry(setting, now)
    else
      check_fixed_time_entry(strategy, setting, now)
    end
  end

  def check_fixed_time_entry(strategy, setting, now)
    return { noop: true, reason: 'not_entry_time' } unless strategy.entry_signal?(now)

    open_position(strategy, setting, GmoCoinApi.get_price)
  end

  def check_dip_bounce_entry(setting, now)
    day_open = dip_bounce_day_open
    return { noop: true, reason: 'no_day_open' } unless day_open

    current_price = GmoCoinApi.get_price
    return { noop: true, reason: 'no_price' } unless current_price
    unless FxStrategies::DipBounce.entry_signal?(now, day_open, current_price)
      return { noop: true, reason: 'not_entry_time' }
    end

    open_position(FxStrategies::DipBounce, setting, current_price)
  end

  def open_position(strategy, setting, price)
    claim = claim_once(strategy: strategy::KEY, event: 'entry', side: strategy::ENTRY_SIDE, size: setting.size)
    return { skipped: true, reason: 'already_entered' } unless claim

    begin
      position, = GmoCoinApi.get_position
      raise "unexpected open position already at broker: #{position.inspect}" if position

      send_order(strategy::ENTRY_SIDE, setting.size)
      claim.update!(price:)
    rescue StandardError
      claim.destroy
      raise
    end
    { entered: true, price: }
  end

  def ensure_entry_price(entry)
    return entry if entry.price

    price = GmoCoinApi.get_price
    entry.update!(price:) if price
    entry
  end

  # dip_bounceの「暦日の始値」。当日最初のバッチ呼び出しでGMOから取得して記録し、
  # 以降はその値を使い続ける(claim_onceと同じ「先着1回だけ記録」の仕組みを流用)
  def dip_bounce_day_open
    key = FxStrategies::DipBounce::KEY
    existing = FxTradeLog.find_by(trade_date: Date.current, strategy: key, event: 'daily_open')
    return existing.price.to_f if existing

    price = GmoCoinApi.get_price
    return nil unless price

    claimed = claim_once(strategy: key, event: 'daily_open', price:)
    (claimed || FxTradeLog.find_by(trade_date: Date.current, strategy: key, event: 'daily_open'))&.price.to_f
  end

  def send_order(side, size)
    side == 'SELL' ? GmoCoinApi.send_sell(size) : GmoCoinApi.send_buy(size)
  end

  def opposite_side(side)
    side == 'SELL' ? 'BUY' : 'SELL'
  end

  # trade_date+strategy+eventの一意制約に先に通った呼び出しだけがclaimを得られる(=発注してよい)
  def claim_once(attrs)
    FxTradeLog.create!({ trade_date: Date.current }.merge(attrs))
  rescue ActiveRecord::RecordNotUnique
    nil
  end
end
