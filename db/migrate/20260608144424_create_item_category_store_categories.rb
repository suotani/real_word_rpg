class CreateItemCategoryStoreCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :item_category_store_categories do |t|
      t.references :item_category,  null: false, foreign_key: true
      t.references :store_category, null: false, foreign_key: true
      t.timestamps
    end
    add_index :item_category_store_categories, [:item_category_id, :store_category_id], unique: true,
              name: 'index_item_category_store_categories_unique'

    # 既存の store_category_id を中間テーブルへ移行してから列を削除
    reversible do |dir|
      dir.up do
        execute <<~SQL
          INSERT INTO item_category_store_categories (item_category_id, store_category_id, created_at, updated_at)
          SELECT id, store_category_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
          FROM item_categories
          WHERE store_category_id IS NOT NULL
        SQL
      end
    end

    remove_column :item_categories, :store_category_id, :integer
  end
end
