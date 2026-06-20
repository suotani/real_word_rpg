class AddSortKeyToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :sort_key, :string
  end
end
