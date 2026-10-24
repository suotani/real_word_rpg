# FX戦略の実行ログ。admin画面(/admin/resources/fx_trade_log)で閲覧できる。
# strategy: ny_rollover_dip / goto_bi_fixing / dip_bounce
# event: start(手動起動時等) / daily_open(dip_bounceの当日始値記録) / entry / close / error
# reason: close時のみ time_exit(時刻決済) / stop_loss(損切り) / handoff(優先戦略への明け渡し決済)
# margin: close時のみ、決済直後に取得したFX取引余力(availableAmount)
class FxTradeLog < ApplicationRecord
  # 当日・その戦略の「決済が済んでいないentry」を返す(=現在保有中とみなす)
  def self.open_entry(strategy, trade_date: Date.current)
    entry = find_by(trade_date:, strategy:, event: 'entry')
    return nil unless entry

    exists?(trade_date:, strategy:, event: 'close') ? nil : entry
  end
end
