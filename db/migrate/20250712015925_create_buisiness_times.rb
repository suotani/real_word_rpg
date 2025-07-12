class CreateBuisinessTimes < ActiveRecord::Migration[7.2]
  def change
    create_table :buisiness_times do |t|
      t.references :item_category, null: false, foreign_key: true
      t.integer :sales_at, null: false
      t.timestamps
    end
  end
end
