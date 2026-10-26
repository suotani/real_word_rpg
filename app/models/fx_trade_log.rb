# FX戦略の実行ログ。admin画面(/admin/resources/fx_trade_log)で閲覧できる。
# strategy: ny_rollover_dip / goto_bi_fixing / dip_bounce
# event: start(手動起動時等) / daily_open(dip_bounceの当日始値記録) / entry / close / error
# reason: close時のみ time_exit(時刻決済) / stop_loss(損切り) / handoff(優先戦略への明け渡し決済)
# margin: close時のみ、決済直後に取得したFX取引余力(availableAmount)
# loss_gain: close時のみ、entryとcloseの価格差 x サイズで計算した決済損益(円、符号あり)
class FxTradeLog < ApplicationRecord
  EVENT_LABELS = {
    'start' => '起動',
    'daily_open' => '始値記録',
    'entry' => 'エントリー',
    'close' => '決済',
    'error' => 'エラー'
  }.freeze

  REASON_LABELS = {
    'time_exit' => '時刻決済',
    'stop_loss' => '損切り',
    'handoff' => '明け渡し決済',
    'holding' => '保有継続',
    'disabled' => '停止中',
    'already_closed' => '決済済み(重複)',
    'already_entered' => '発注済み(重複)',
    'not_entry_time' => 'エントリー時刻外',
    'no_day_open' => '始値未取得',
    'no_price' => '価格取得失敗'
  }.freeze

  # 当日・その戦略の「決済が済んでいないentry」を返す(=現在保有中とみなす)
  def self.open_entry(strategy, trade_date: Date.current)
    entry = find_by(trade_date:, strategy:, event: 'entry')
    return nil unless entry

    exists?(trade_date:, strategy:, event: 'close') ? nil : entry
  end

  def event_label
    EVENT_LABELS.fetch(event, event)
  end

  def reason_label
    return nil if reason.blank?

    REASON_LABELS.fetch(reason, reason)
  end
end
