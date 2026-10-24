# FXトレードボット(実資金を扱う)の稼働状況をまとめて見る管理者専用ダッシュボード。
# 各戦略の稼働状況(enabled)・発注サイズ(size)・損切り(stop_loss_yen)はこの画面から
# そのまま編集できる。docs/fx_trade_bot.md の注意点を参照。緊急停止は各戦略の
# enabled を false にすること。
class Admin::FxBotSettingsController < Admin::ApplicationController
  def show
    @settings = FxBotSetting.order(:strategy)
    @recent_logs = FxTradeLog.order(created_at: :desc).limit(20)
    @latest_margin_log = FxTradeLog.where(event: 'close').where.not(margin: nil).order(created_at: :desc).first
  end

  def update
    setting = FxBotSetting.find(params[:id])
    if setting.update(fx_bot_setting_params)
      redirect_to admin_fx_bot_setting_path, notice: "#{setting.strategy} の設定を更新しました"
    else
      redirect_to admin_fx_bot_setting_path, alert: setting.errors.full_messages.join('、')
    end
  end

  private

  def fx_bot_setting_params
    params.require(:fx_bot_setting).permit(:enabled, :size, :stop_loss_yen)
  end
end
