class AddBasePriceToStocks < ActiveRecord::Migration[7.2]
  def up
    add_column :stocks, :base_price, :integer
    execute 'UPDATE stocks SET base_price = price'
    change_column_null :stocks, :base_price, false
  end

  def down
    remove_column :stocks, :base_price
  end
end
