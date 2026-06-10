require 'csv'

class StoreCategoriesImporter
  CSV_PATH = Rails.root.join('db/seeds/store_categories.csv')

  # CSV から StoreCategory（listing_fee / sales_hours / 売ることができる商品カテゴリ）を同期する。
  # 既存の同名カテゴリは値を更新し、BuisinessTime も再同期する。
  # item_categories 列はセミコロン区切りで、その店舗カテゴリで売ることができる ItemCategory を列挙する。
  def self.import!
    new.import!
  end

  def import!
    CSV.foreach(CSV_PATH, headers: true) do |row|
      store_category = StoreCategory.find_or_initialize_by(name: row['name'].strip)
      store_category.listing_fee = row['listing_fee'].to_i
      store_category.sales_hours = row['sales_hours'].to_s.strip
      store_category.save!
      store_category.sync_buisiness_times!

      row['item_categories'].to_s.split(';').map(&:strip).reject(&:empty?).each do |item_category_name|
        item_category = ItemCategory.find_or_create_by!(name: item_category_name)
        ItemCategoryStoreCategory.find_or_create_by!(item_category: item_category, store_category: store_category)
      end
    end
  end
end
