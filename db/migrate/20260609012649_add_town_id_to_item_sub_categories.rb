class AddTownIdToItemSubCategories < ActiveRecord::Migration[7.2]
  def change
    add_reference :item_sub_categories, :town, null: true, foreign_key: true
  end
end
