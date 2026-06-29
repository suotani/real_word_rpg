require 'rails_helper'

RSpec.describe MarketPriceFluctuationService do
  subject(:service) { described_class.new }

  describe '#run' do
    context '中央卸売市場が存在しない場合' do
      it 'updated: 0 で正常終了する' do
        result = service.run
        expect(result[:updated]).to eq(0)
        expect(result[:errors]).to be_empty
      end
    end

    context '中央卸売市場が存在する場合' do
      let!(:wholesale_category) { create(:store_category, name: '卸市場') }
      let!(:market) do
        create(:store, name: '中央卸売市場', user: nil, town: nil,
                       store_category: wholesale_category)
      end
      let!(:stock1) { create(:stock, store: market, user: nil, item_sub_category: nil, price: 100, listed: true) }
      let!(:stock2) { create(:stock, store: market, user: nil, item_sub_category: nil, price:  50, listed: true) }

      it '全stockの更新件数を返す' do
        result = service.run
        expect(result[:updated]).to eq(2)
        expect(result[:errors]).to be_empty
      end

      it 'それぞれのstockの価格が -5〜+5 の範囲内で変動する' do
        originals = { stock1.id => stock1.price, stock2.id => stock2.price }
        service.run
        [stock1, stock2].each do |stock|
          old_price = originals[stock.id]
          new_price = stock.reload.price
          expect(new_price).to be_between([old_price - 5, 1].max, old_price + 5)
        end
      end

      it '価格が1円を下回らない' do
        stock1.update!(price: 1)
        service.run
        expect(stock1.reload.price).to be >= 1
      end
    end
  end
end
