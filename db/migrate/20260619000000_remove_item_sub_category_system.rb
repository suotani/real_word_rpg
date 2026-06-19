class RemoveItemSubCategorySystem < ActiveRecord::Migration[7.2]
  def up
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end

    # RecipeItemSubCategory → RecipeIngredient にデータ移行（カラムが存在する場合のみ）
    if column_exists?(:recipe_item_sub_categories, :recipe_id)
      execute <<~SQL
        INSERT INTO recipe_ingredients (recipe_id, name, created_at, updated_at)
        SELECT risc.recipe_id, isc.name, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
        FROM recipe_item_sub_categories risc
        JOIN item_sub_categories isc ON isc.id = risc.item_sub_category_id
      SQL
    end

    drop_table :recipe_item_sub_categories, force: :cascade
    remove_reference :stocks, :item_sub_category, foreign_key: true
    drop_table :item_sub_categories, force: :cascade
  end

  def down
    create_table :item_sub_categories do |t|
      t.string :name, null: false
      t.references :item_category, foreign_key: true
      t.references :town, foreign_key: true
      t.timestamps
    end

    create_table :recipe_item_sub_categories do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :item_sub_category, null: false, foreign_key: true
      t.timestamps
    end

    add_reference :stocks, :item_sub_category, foreign_key: true

    drop_table :recipe_ingredients, force: :cascade
  end
end
