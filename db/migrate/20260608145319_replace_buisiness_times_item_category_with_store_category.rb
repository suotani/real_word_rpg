class ReplaceBuisinessTimesItemCategoryWithStoreCategory < ActiveRecord::Migration[7.2]
  def change
    # 意味が変わるので既存データは削除
    execute "DELETE FROM buisiness_times"

    remove_foreign_key :buisiness_times, :item_categories
    remove_column :buisiness_times, :item_category_id, :integer

    add_reference :buisiness_times, :store_category, null: false, foreign_key: true
  end
end
