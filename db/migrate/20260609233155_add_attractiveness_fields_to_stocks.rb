class AddAttractivenessFieldsToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :ingredient_count, :integer, null: false, default: 0
    add_column :stocks, :unsold_count, :integer, null: false, default: 0
    add_column :stocks, :attractiveness, :float, null: false, default: 0.0
  end
end
