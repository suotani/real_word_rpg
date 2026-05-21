class RedesignStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :name, :string
    add_reference :stocks, :item_sub_category, foreign_key: true

    remove_foreign_key :stocks, :items
    remove_column :stocks, :item_id, :integer
  end
end
