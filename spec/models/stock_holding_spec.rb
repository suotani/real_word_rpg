require 'rails_helper'

RSpec.describe StockHolding do
  describe '.register!' do
    it '新規コードなら新しいレコードを作成する' do
      expect do
        described_class.register!(code: '6526', name: 'ソシオネクスト', price: 2000.0)
      end.to change(described_class, :count).by(1)

      holding = described_class.find_by(code: '6526')
      expect(holding.name).to eq('ソシオネクスト')
      expect(holding.bought_price).to eq(2000.0)
    end

    it '既存コードなら価格・日時を更新する(新規作成しない)' do
      described_class.register!(code: '6526', name: 'ソシオネクスト', price: 2000.0)

      expect do
        described_class.register!(code: '6526', name: 'ソシオネクスト', price: 2200.0)
      end.not_to change(described_class, :count)

      expect(described_class.find_by(code: '6526').bought_price).to eq(2200.0)
    end
  end

  describe '#price_change_pct' do
    it '購入価格からの変動率を計算する' do
      holding = described_class.new(bought_price: 2000.0)
      expect(holding.price_change_pct(2200.0)).to eq(10.0)
    end

    it '現在価格が無い場合はnilを返す' do
      holding = described_class.new(bought_price: 2000.0)
      expect(holding.price_change_pct(nil)).to be_nil
    end
  end
end
