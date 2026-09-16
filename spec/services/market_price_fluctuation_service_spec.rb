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
      let!(:stock1) do
        create(:stock, store: market, user: nil, item_sub_category: nil,
                       base_price: 100, price: 999, listed: true)
      end
      let!(:stock2) do
        create(:stock, store: market, user: nil, item_sub_category: nil,
                       base_price: 50, price: 1, listed: true)
      end

      it '全stockの更新件数を返す' do
        result = service.run
        expect(result[:updated]).to eq(2)
        expect(result[:errors]).to be_empty
      end

      it '前回の価格に関わらず、基準価格を中心に価格が再計算される' do
        allow_any_instance_of(described_class).to receive(:standard_normal).and_return(0.0)
        service.run
        expect(stock1.reload.price).to eq(stock1.base_price)
        expect(stock2.reload.price).to eq(stock2.base_price)
      end

      it '基準価格の10%を標準偏差として価格が変動する' do
        allow_any_instance_of(described_class).to receive(:standard_normal).and_return(1.0)
        service.run
        expect(stock1.reload.price).to eq(110) # 100 + 100 * 0.1 * 1.0
        expect(stock2.reload.price).to eq(55)  # 50 + 50 * 0.1 * 1.0
      end

      it '価格が1円を下回らない' do
        allow_any_instance_of(described_class).to receive(:standard_normal).and_return(-100.0)
        service.run
        expect(stock1.reload.price).to eq(1)
        expect(stock2.reload.price).to eq(1)
      end
    end
  end
end
