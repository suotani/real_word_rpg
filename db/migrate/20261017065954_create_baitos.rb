class CreateBaitos < ActiveRecord::Migration[7.2]
  def change
    create_table :baitos do |t|
      t.references :store, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.string :pricing_mode, null: false, default: 'fixed'
      t.integer :fixed_price
      t.float :price_multiplier

      t.timestamps
    end

    add_index :baitos, [:store_id, :recipe_id], unique: true
  end
end
