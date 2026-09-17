class CreateWholesaleItemRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :wholesale_item_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :item_category, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :base_price, null: false
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end

    add_index :wholesale_item_requests, [:user_id, :status]
  end
end
