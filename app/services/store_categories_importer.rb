require 'csv'
# bin/rails runner "StoreCategoriesImporter.import!"
class StoreCategoriesImporter
  CSV_PATH = Rails.root.join('db/seeds/store_categories.csv')

  # CSV から StoreCategory（listing_fee / sales_hours / 売ることができる商品カテゴリ）を同期する。
  # 既存の同名カテゴリはスキップし、未登録のカテゴリのみ新規登録する。
  # CSV に存在しないカテゴリは関連レコード（店舗・在庫・レシピ等）を含めて削除する。
  # item_categories 列はセミコロン区切りで、その店舗カテゴリで売ることができる ItemCategory を列挙する。
  # CSV のどの行の item_categories にも存在しない ItemCategory は削除する
  # （ただし ItemSubCategory が紐づいている場合は削除しない）。
  def self.import!
    new.import!
  end

  def import!
    csv_names = []
    item_category_names = []

    CSV.foreach(CSV_PATH, headers: true) do |row|
      name = row['name'].strip
      csv_names << name

      row_item_category_names = row['item_categories'].to_s.split(';').map(&:strip).reject(&:empty?)
      item_category_names.concat(row_item_category_names)

      next if StoreCategory.exists?(name: name)

      store_category = StoreCategory.create!(
        name: name,
        listing_fee: row['listing_fee'].to_i,
        sales_hours: row['sales_hours'].to_s.strip
      )
      store_category.sync_buisiness_times!

      row_item_category_names.each do |item_category_name|
        item_category = ItemCategory.find_or_create_by!(name: item_category_name)
        ItemCategoryStoreCategory.find_or_create_by!(item_category: item_category, store_category: store_category)
      end
    end

    StoreCategory.where.not(name: csv_names).destroy_all

    ItemCategory.where.not(name: item_category_names.uniq).find_each do |item_category|
      next if item_category.item_sub_categories.exists?

      item_category.destroy!
    end
  end
end
