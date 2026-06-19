require 'csv'

class WholesaleItemsImporter
  CSV_PATH = Rails.root.join('db/seeds/wholesale_items.csv')

  # CSV を読み込み、グローバルな ItemSubCategory を生成してグローバル中央卸売市場へ追加する。
  def self.import!
    new.import!
  end

  # 新規に作成した ItemSubCategory の件数を返す
  def import!
    created_count = 0

    CSV.foreach(CSV_PATH, headers: true) do |row|
      item_cat_name = row['item_category'].strip
      sub_cat_name  = row['item_sub_category'].strip

      item_category = ItemCategory.find_or_create_by!(name: item_cat_name)

      # グローバル（town_id: nil）に同名のサブカテゴリが既になければ作成
      unless ItemSubCategory.exists?(name: sub_cat_name, town_id: nil, item_category: item_category)
        ItemSubCategory.create!(
          name:          sub_cat_name,
          item_category: item_category,
          town:          nil
        )
        created_count += 1
      end
    end

    created_count
  end
end
