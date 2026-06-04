class CreateRecipeItemSubCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :recipe_item_sub_categories do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :item_sub_category, null: false, foreign_key: true
      t.timestamps
    end
  end
end
