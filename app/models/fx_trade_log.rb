# FXロールオーバー・ディップ戦略の実行ログ。admin画面(/admin/resources/fx_trade_log)で閲覧できる。
# event: start(手動起動時等) / entry / close / error
# reason: close時のみ time_exit(時刻決済) または stop_loss(損切り)
class FxTradeLog < ApplicationRecord
  def self.already_logged_today?(event)
    where(trade_date: Date.current, event:).exists?
  end
end
