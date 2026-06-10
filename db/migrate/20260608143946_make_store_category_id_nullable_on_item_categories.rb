class MakeStoreCategoryIdNullableOnItemCategories < ActiveRecord::Migration[7.2]
  def change
    change_column_null :item_categories, :store_category_id, true
  end
end
