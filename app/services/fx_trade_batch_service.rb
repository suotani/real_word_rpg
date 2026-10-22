# 「NYロールオーバー・ディップ」戦略のバッチ本体。cron(Render cronサービス)から
# 1分ごとにHTTP経由で呼ばれる想定で、「1回呼ばれたら今の状態を見て1つだけ判断する」
# ワンショットの作りになっている(fx/ny_rollover_live.rb の常駐ループ版とは違い、
# プロセスを常駐させずcronの1回1回が独立して安全に動くように設計してある)。
#
# 二重発注防止: エントリー/決済のたびに FxTradeLog へ「予約」を1行作成してから
# 実際にGMO APIへ発注する。DBの一意制約(1日1回まで)が先に通った場合だけ発注するので、
# cronが同じ分に重複して呼ばれても二重発注にならない。発注自体が失敗した場合は予約行を
# 削除し、次回のcron呼び出しで再試行できるようにする。
class FxTradeBatchService
  def run
    setting = FxBotSetting.instance
    return { skipped: true, reason: 'disabled' } unless setting.enabled

    now = Time.current
    position, size, loss_gain = GmoCoinApi.get_position

    if position
      handle_open_position(setting, now, position, size, loss_gain)
    else
      handle_no_position(setting, now)
    end
  rescue StandardError => e
    FxTradeLog.create!(trade_date: Date.current, event: 'error', note: "#{e.class}: #{e.message}")
    { error: e.message }
  end

  private

  def handle_open_position(setting, now, position, size, loss_gain)
    stop_hit = loss_gain && loss_gain <= -(setting.stop_loss_yen * size)
    time_hit = time_at_or_after?(now, setting.exit_hour, setting.exit_min)
    return { noop: true, reason: 'holding' } unless stop_hit || time_hit

    reason = stop_hit ? 'stop_loss' : 'time_exit'
    claim = claim_once(event: 'close', reason:, side: position, size:, loss_gain:)
    return { skipped: true, reason: 'already_closed' } unless claim

    begin
      GmoCoinApi.send_buy(size) # SHORTの決済は常にBUY
    rescue StandardError
      claim.destroy # 発注失敗時は予約を取り消し、次回のcronで再試行できるようにする
      raise
    end

    # 決済は成功している(=実際に発注済み)ので、ここで余力取得が失敗しても
    # claimは取り消さない(取得失敗時はnilのまま記録され、原因はRails.loggerに出る)
    margin = GmoCoinApi.get_margin
    claim.update!(margin:) if margin
    { closed: true, reason:, margin: }
  end

  def handle_no_position(setting, now)
    unless now.hour == setting.entry_hour && now.min == setting.entry_min
      return { noop: true, reason: 'not_entry_time' }
    end

    claim = claim_once(event: 'entry', side: 'SELL', size: setting.size)
    return { skipped: true, reason: 'already_entered' } unless claim

    begin
      price = GmoCoinApi.get_price
      GmoCoinApi.send_sell(setting.size)
      claim.update!(price:)
    rescue StandardError
      claim.destroy
      raise
    end
    { entered: true }
  end

  # trade_date+eventの一意制約に先に通った呼び出しだけがclaimを得られる(=発注してよい)
  def claim_once(attrs)
    FxTradeLog.create!({ trade_date: Date.current }.merge(attrs))
  rescue ActiveRecord::RecordNotUnique
    nil
  end

  def time_at_or_after?(now, hour, min)
    now.hour > hour || (now.hour == hour && now.min >= min)
  end
end
