class AddColumnShopPointToCharactor < ActiveRecord::Migration[5.2]
  def change
    add_column :charactors, :shop_point, :integer, default: 0
    add_column :tickets, :point, :integer, default: 100
  end
end
