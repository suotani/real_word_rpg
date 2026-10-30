# 4本目の戦略(NyRolloverRebound、①NyRolloverDipの決済直後の反発を狙うBUY)を追加する。
class AddNyRolloverReboundFxBotSetting < ActiveRecord::Migration[7.2]
  def up
    # 新規戦略は安全のためデフォルト停止(enabled: false)で追加する
    FxBotSetting.create!(strategy: 'ny_rollover_rebound', enabled: false, size: 1000, stop_loss_yen: 0.3)
  end

  def down
    FxBotSetting.where(strategy: 'ny_rollover_rebound').delete_all
  end
end
