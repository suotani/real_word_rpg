class CreateStoreCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :store_categories do |t|
      t.string :name, null: false
      t.timestamps
    end

    StoreCategory.create(name: "飲食店")
    StoreCategory.create(name: "アパレル")
    StoreCategory.create(name: "サービス")
    StoreCategory.create(name: "雑貨")
    StoreCategory.create(name: "食料品")
    StoreCategory.create(name: "その他")
  end
end
