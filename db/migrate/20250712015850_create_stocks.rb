class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.references :item, null: false, foreign_key: true
      t.references :store, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :cost, null: false
      t.integer :price, null: false
      t.timestamps
    end
  end
end
