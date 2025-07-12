class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.references :town, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description, null: false
      t.references :item_category, null: false, foreign_key: true, comment: "アイテムカテゴリ"
      t.timestamps
    end
  end
end
