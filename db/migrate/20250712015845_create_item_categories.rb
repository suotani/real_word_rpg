class CreateItemCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :item_categories do |t|
      t.references :store_category, null: false, foreign_key: true
      t.string :name, null: false
      t.timestamps
    end

    id = StoreCategory.find_by(name: "飲食店").id
    ItemCategory.create(name: "軽食", store_category_id: id)
    ItemCategory.create(name: "ランチ", store_category_id: id)
    ItemCategory.create(name: "ディナー", store_category_id: id)
    ItemCategory.create(name: "居酒屋/バー", store_category_id: id)
    
    id = StoreCategory.find_by(name: "アパレル").id
    ItemCategory.create(name: "服", store_category_id: id)
    ItemCategory.create(name: "靴", store_category_id: id)
    ItemCategory.create(name: "帽子", store_category_id: id)

    id = StoreCategory.find_by(name: "サービス").id
    ItemCategory.create(name: "美容院", store_category_id: id)
    ItemCategory.create(name: "マッサージ", store_category_id: id)
    ItemCategory.create(name: "塾", store_category_id: id)

    id = StoreCategory.find_by(name: "雑貨").id
    ItemCategory.create(name: "文房具", store_category_id: id)
    ItemCategory.create(name: "日用品", store_category_id: id)
    ItemCategory.create(name: "おもちゃ", store_category_id: id)

    id = StoreCategory.find_by(name: "食料品").id
    ItemCategory.create(name: "野菜", store_category_id: id)
    ItemCategory.create(name: "果物", store_category_id: id)
    ItemCategory.create(name: "肉魚", store_category_id: id)
    ItemCategory.create(name: "パン/ご飯", store_category_id: id)
    ItemCategory.create(name: "おかし", store_category_id: id)
  end
end
