class CreateStockHoldings < ActiveRecord::Migration[7.2]
  def change
    create_table :stock_holdings do |t|
      t.string :code, null: false
      t.string :name
      t.decimal :bought_price, precision: 12, scale: 2, null: false
      t.datetime :bought_at, null: false

      t.timestamps
    end
    add_index :stock_holdings, :code, unique: true
  end
end
