class DropItems < ActiveRecord::Migration[7.2]
  def change
    drop_table :items do |t|
      t.integer :town_id, null: false
      t.string :name, null: false
      t.integer :item_category_id, null: false
      t.integer :store_id
      t.timestamps
    end
  end
end
