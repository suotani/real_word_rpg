class CreateItemSubCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :item_sub_categories do |t|
      t.references :item_category, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end
  end
end
