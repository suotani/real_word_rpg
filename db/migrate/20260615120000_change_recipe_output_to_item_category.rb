class ChangeRecipeOutputToItemCategory < ActiveRecord::Migration[7.2]
  def up
    add_reference :recipes, :item_category, null: true, foreign_key: true

    execute <<~SQL
      UPDATE recipes
      SET item_category_id = (
        SELECT item_sub_categories.item_category_id
        FROM item_sub_categories
        WHERE item_sub_categories.id = recipes.item_sub_category_id
      )
      WHERE recipes.item_sub_category_id IS NOT NULL
    SQL

    remove_reference :recipes, :item_sub_category, foreign_key: true
  end

  def down
    add_reference :recipes, :item_sub_category, null: true, foreign_key: true
    remove_reference :recipes, :item_category, foreign_key: true
  end
end
