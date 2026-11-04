require 'rails_helper'

RSpec.describe StockScreeningRun do
  describe '.sell_time?' do
    it 'sell_threshold_price以上なら売り時と判定する' do
      row = { 'price' => 3000.0, 'sell_threshold_price' => 2900.0 }
      expect(described_class.sell_time?(row)).to eq(true)
    end

    it 'sell_threshold_price未満なら売り時ではない' do
      row = { 'price' => 2000.0, 'sell_threshold_price' => 2100.0 }
      expect(described_class.sell_time?(row)).to eq(false)
    end

    it 'latest_price(現在価格更新後)がある場合はpriceより優先する' do
      row = { 'price' => 2000.0, 'latest_price' => 3000.0, 'sell_threshold_price' => 2900.0 }
      expect(described_class.sell_time?(row)).to eq(true)
    end

    it 'sell_threshold_priceが無い(旧形式)場合はfalse' do
      row = { 'price' => 3000.0 }
      expect(described_class.sell_time?(row)).to eq(false)
    end

    it 'priceもlatest_priceも無い場合はfalse' do
      row = { 'sell_threshold_price' => 2900.0 }
      expect(described_class.sell_time?(row)).to eq(false)
    end
  end
end
