class AddSalesHoursToStoreCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :store_categories, :sales_hours, :string, default: ''
  end
end
