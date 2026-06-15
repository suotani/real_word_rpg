require 'csv'

class WholesaleItemsImporter
  CSV_PATH = Rails.root.join('db/seeds/wholesale_items.csv')

  # CSV を読み込み、中央卸売市場へ商品を登録する。
  # town を指定するとその町用の ItemSubCategory を生成する（市場への自動追加も走る）。
  # town が nil の場合は ItemCategory のみ同期してサブカテゴリは生成しない。
  def self.import!(town: nil)
    new(town: town).import!
  end

  def initialize(town: nil)
    @town = town
  end

  # 新規に作成した ItemSubCategory の件数を返す
  def import!
    created_count = 0

    CSV.foreach(CSV_PATH, headers: true) do |row|
      item_cat_name = row['item_category'].strip
      sub_cat_name  = row['item_sub_category'].strip

      item_category = ItemCategory.find_or_create_by!(name: item_cat_name)

      next unless @town

      # 同じ町に同名のサブカテゴリが既になければ作成
      unless ItemSubCategory.exists?(name: sub_cat_name, town: @town, item_category: item_category)
        ItemSubCategory.create!(
          name:          sub_cat_name,
          item_category: item_category,
          town:          @town
        )
        created_count += 1
      end
    end

    created_count
  end
end
