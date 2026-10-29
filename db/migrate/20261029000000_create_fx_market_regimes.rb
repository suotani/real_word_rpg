class CreateFxMarketRegimes < ActiveRecord::Migration[7.2]
  def change
    create_table :fx_market_regimes do |t|
      t.string :trend, null: false   # 'up' / 'down'(1時間足SMA50 vs SMA200)
      t.datetime :computed_at, null: false

      t.timestamps
    end

    add_index :fx_market_regimes, :computed_at
  end
end
