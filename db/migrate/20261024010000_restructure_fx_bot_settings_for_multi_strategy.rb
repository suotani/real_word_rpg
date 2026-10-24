# 複数戦略(NYロールオーバー・ディップ/ゴトー日仲値/ディップ・バウンス)対応のため、
# FxBotSettingを「シングルトン1行」から「戦略ごとに1行」に変更する。
# エントリー/決済時刻は戦略ごとに異なり固定なので、admin画面の数値設定ではなく
# app/services/fx_strategies/ 配下のコードに決め打ちで持たせる(entry_hour等は削除)。
class RestructureFxBotSettingsForMultiStrategy < ActiveRecord::Migration[7.2]
  def up
    add_column :fx_bot_settings, :strategy, :string
    FxBotSetting.reset_column_information
    FxBotSetting.update_all(strategy: 'ny_rollover_dip')
    change_column_null :fx_bot_settings, :strategy, false
    add_index :fx_bot_settings, :strategy, unique: true

    remove_column :fx_bot_settings, :entry_hour
    remove_column :fx_bot_settings, :entry_min
    remove_column :fx_bot_settings, :exit_hour
    remove_column :fx_bot_settings, :exit_min
    FxBotSetting.reset_column_information

    # 新規2戦略は安全のためデフォルト停止(enabled: false)で追加する
    FxBotSetting.create!(strategy: 'goto_bi_fixing', enabled: false, size: 1000, stop_loss_yen: 0.15)
    FxBotSetting.create!(strategy: 'dip_bounce',     enabled: false, size: 1000, stop_loss_yen: 0.3)
  end

  def down
    FxBotSetting.where(strategy: %w[goto_bi_fixing dip_bounce]).delete_all
    add_column :fx_bot_settings, :entry_hour, :integer, null: false, default: 6
    add_column :fx_bot_settings, :entry_min,  :integer, null: false, default: 50
    add_column :fx_bot_settings, :exit_hour,  :integer, null: false, default: 7
    add_column :fx_bot_settings, :exit_min,   :integer, null: false, default: 5
    remove_index :fx_bot_settings, :strategy
    remove_column :fx_bot_settings, :strategy
  end
end
