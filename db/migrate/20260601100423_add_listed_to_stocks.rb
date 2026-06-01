class AddListedToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :listed, :boolean, null: false, default: false
  end
end
