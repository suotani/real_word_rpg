# FXトレードボット(実資金を扱う)の稼働状況をまとめて見る管理者専用ダッシュボード。
# 各戦略のenabled/size/stop_loss_yenの編集は汎用の /admin/resources/fx_bot_setting
# (Admin::ResourcesController)を使う。docs/fx_trade_bot.md の注意点を参照。
# 緊急停止は各戦略の enabled を false にすること。
class Admin::FxBotSettingsController < Admin::ApplicationController
  def show
    @settings = FxBotSetting.order(:strategy)
    @recent_logs = FxTradeLog.order(created_at: :desc).limit(20)
    @latest_margin_log = FxTradeLog.where(event: 'close').where.not(margin: nil).order(created_at: :desc).first
  end
end
