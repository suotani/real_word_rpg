require 'csv'

class WholesaleItemsImporter
  CSV_PATH = Rails.root.join('db/seeds/wholesale_items.csv')

  def self.import!
    new.import!
  end

  def import!
    market = Store.central_wholesale_market
    raise '中央卸売市場が存在しません。' unless market

    created_count = 0

    CSV.foreach(CSV_PATH, headers: true) do |row|
      name = row['item_sub_category']&.strip
      next if name.blank?

      unless market.stocks.exists?(name: name)
        market.stocks.create!(
          name:  name,
          cost:  0,
          price: 100,
          user:  nil
        )
        created_count += 1
      end
    end

    created_count
  end
end
