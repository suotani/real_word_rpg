class CreateStores < ActiveRecord::Migration[7.2]
  def change
    create_table :stores do |t|
      t.references :town, null: false, foreign_key: true
      t.string :name, null: false
      t.string :theme_color, null: false
      t.string :theme_sub_color, null: false
      t.references :user, null: false, foreign_key: true, comment: "店主"
      t.references :store_category, null: false, foreign_key: true, comment: "店舗カテゴリ"
      t.timestamps
    end
  end
end
