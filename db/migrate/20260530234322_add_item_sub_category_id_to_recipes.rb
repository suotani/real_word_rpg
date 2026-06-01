class AddItemSubCategoryIdToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_reference :recipes, :item_sub_category, null: true, foreign_key: true
  end
end
