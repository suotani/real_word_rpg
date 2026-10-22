class CreateFxTradeLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :fx_trade_logs do |t|
      t.date :trade_date, null: false
      t.string :event, null: false   # start / entry / close / error
      t.string :reason               # close時のみ: time_exit / stop_loss
      t.string :side
      t.integer :size
      t.decimal :price, precision: 10, scale: 3
      t.decimal :loss_gain, precision: 12, scale: 3
      t.text :note

      t.timestamps
    end

    # entry/closeは1日1回しか成立しないように、DBレベルで二重発注を防ぐ
    # (cronの重複実行や再試行で同じ日に2回発注されることを防ぐための一意制約)
    add_index :fx_trade_logs, [:trade_date, :event],
              unique: true,
              where: "event IN ('entry','close')",
              name: 'idx_fx_trade_logs_claim'
  end
end
