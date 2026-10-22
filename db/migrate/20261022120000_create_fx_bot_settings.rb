class CreateFxBotSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :fx_bot_settings do |t|
      t.boolean :enabled, null: false, default: false # falseの間はFxTradeBatchServiceが即座にskipして終了する
      t.integer :size, null: false, default: 1000
      t.decimal :stop_loss_yen, precision: 10, scale: 3, null: false, default: 0.15
      t.integer :entry_hour, null: false, default: 6
      t.integer :entry_min, null: false, default: 50
      t.integer :exit_hour, null: false, default: 7
      t.integer :exit_min, null: false, default: 5

      t.timestamps
    end
  end
end
