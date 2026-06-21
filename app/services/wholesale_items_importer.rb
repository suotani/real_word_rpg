require 'csv'

class WholesaleItemsImporter
  CSV_PATH = Rails.root.join('db/seeds/wholesale_items.csv')

  def self.import!(town:)
    new(town).import!
  end

  # seeds.rb 用: グローバル（town_id: nil）な ItemSubCategory を生成する
  def self.import_global!
    created_count = 0
    CSV.foreach(CSV_PATH, headers: true) do |row|
      item_cat_name = row['item_category'].strip
      sub_cat_name  = row['item_sub_category'].strip
      item_category = ItemCategory.find_or_create_by!(name: item_cat_name)
      unless ItemSubCategory.exists?(name: sub_cat_name, town_id: nil, item_category: item_category)
        ItemSubCategory.create!(name: sub_cat_name, item_category: item_category, town: nil)
        created_count += 1
      end
    end
    created_count
  end

  def initialize(town)
    @town = town
  end

  # 新規に作成した ItemSubCategory の件数を返す
  def import!
    return 0 if @town.nil?

    created_count = 0
    CSV.foreach(CSV_PATH, headers: true) do |row|
      item_cat_name = row['item_category'].strip
      sub_cat_name  = row['item_sub_category'].strip
      item_category = ItemCategory.find_or_create_by!(name: item_cat_name)
      unless ItemSubCategory.exists?(name: sub_cat_name, town_id: @town.id, item_category: item_category)
        ItemSubCategory.create!(name: sub_cat_name, item_category: item_category, town: @town)
        created_count += 1
      end
    end
    created_count
  end
end
