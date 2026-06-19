class AddIngredientToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :ingredient, :boolean, default: false, null: false
  end
end
