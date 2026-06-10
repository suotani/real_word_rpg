require 'rails_helper'

RSpec.describe Stock, '魅力度' do
  describe '#calculate_attractiveness' do
    it '仕入れ値・販売価格のみの場合 cost/price になる' do
      stock = build(:stock, cost: 100, price: 200, ingredient_count: 0, unsold_count: 0)
      expect(stock.calculate_attractiveness).to eq(0.5)
    end

    it '素材数が多いほど魅力度が上がる' do
      stock = build(:stock, cost: 100, price: 200, ingredient_count: 3, unsold_count: 0)
      expect(stock.calculate_attractiveness).to eq(0.5 + 3 * 0.1)
    end

    it '売れ残り回数が多いほど魅力度が下がる' do
      stock = build(:stock, cost: 100, price: 200, ingredient_count: 0, unsold_count: 2)
      expect(stock.calculate_attractiveness).to eq(0.5 - 2 * 0.05)
    end

    it '販売価格が0以下の場合は0を返す' do
      stock = build(:stock, cost: 100, price: 0)
      expect(stock.calculate_attractiveness).to eq(0.0)
    end
  end

  describe '#recalculate_attractiveness!' do
    it 'attractiveness カラムを再計算結果で更新する' do
      stock = create(:stock, cost: 150, price: 200, ingredient_count: 1, unsold_count: 1)
      stock.recalculate_attractiveness!
      expect(stock.reload.attractiveness).to eq((150.0 / 200) + 0.1 - 0.05)
    end
  end
end
