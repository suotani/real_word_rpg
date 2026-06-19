require 'rails_helper'

RSpec.describe WholesaleItemsImporter do
  describe '.import!' do
    let!(:wholesale_category) { StoreCategory.create!(name: '卸市場', listing_fee: 0) }
    let!(:central_market) { Store.create!(name: '中央卸売市場', user: nil, town: nil, store_category: wholesale_category, theme_color: '#2c3e50', theme_sub_color: '#e8d5b7') }

    it 'CSVの商品が中央卸売市場に新規作成される' do
      expect { described_class.import! }.to change {
        central_market.stocks.reload.count
      }.from(0)
    end

    it '新規作成件数を返す' do
      count = described_class.import!
      expect(count).to eq(central_market.stocks.reload.count)
      expect(count).to be > 0
    end

    it '2回目の実行では新規作成されない（冪等）' do
      described_class.import!
      expect(described_class.import!).to eq(0)
    end
  end
end
