# FXトレードボット(実資金を扱う)の各種パラメータを編集する管理者専用画面。
# docs/fx_trade_bot.md の注意点を参照。enabled を false にするのが緊急停止。
class Admin::FxBotSettingsController < Admin::ApplicationController
  before_action :set_fx_bot_setting

  def show
    @recent_logs = FxTradeLog.order(created_at: :desc).limit(10)
    @latest_margin_log = FxTradeLog.where(event: 'close').where.not(margin: nil).order(created_at: :desc).first
  end

  def edit; end

  def update
    if @fx_bot_setting.update(fx_bot_setting_params)
      redirect_to admin_fx_bot_setting_path, notice: '更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_fx_bot_setting
    @fx_bot_setting = FxBotSetting.instance
  end

  def fx_bot_setting_params
    params.require(:fx_bot_setting).permit(
      :enabled, :size, :stop_loss_yen, :entry_hour, :entry_min, :exit_hour, :exit_min
    )
  end
end
