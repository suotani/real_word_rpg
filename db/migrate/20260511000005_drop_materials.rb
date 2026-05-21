class DropMaterials < ActiveRecord::Migration[7.2]
  def change
    drop_table :materials do |t|
      t.integer :item_id, null: false
      t.integer :amount
      t.integer :recipe_id
      t.timestamps
    end
  end
end
