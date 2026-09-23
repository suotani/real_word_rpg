require 'rails_helper'

RSpec.describe Stock, '魅力度' do
  describe '#calculate_attractiveness' do
    it '基本料金・販売価格のみの場合 base_price/price になる' do
      stock = build(:stock, base_price: 100, price: 200, ingredient_count: 0, unsold_count: 0)
      expect(stock.calculate_attractiveness).to eq(0.5)
    end

    it '素材数が多いほど魅力度が上がる' do
      stock = build(:stock, base_price: 100, price: 200, ingredient_count: 3, unsold_count: 0)
      expect(stock.calculate_attractiveness).to eq(0.5 + 3 * 0.1)
    end

    it '売れ残り回数は魅力度に影響しない' do
      stock = build(:stock, base_price: 100, price: 200, ingredient_count: 0, unsold_count: 2)
      expect(stock.calculate_attractiveness).to eq(0.5)
    end

    it '仕入れ値（cost）は魅力度に影響しない' do
      cheap_cost      = build(:stock, base_price: 100, price: 200, cost: 1)
      expensive_cost  = build(:stock, base_price: 100, price: 200, cost: 199)
      expect(cheap_cost.calculate_attractiveness).to eq(expensive_cost.calculate_attractiveness)
    end

    it '販売価格が0以下の場合は0を返す' do
      stock = build(:stock, base_price: 100, price: 0)
      expect(stock.calculate_attractiveness).to eq(0.0)
    end

    it '店舗の従業員（例: 看板娘）の魅力度ボーナスが加算される' do
      employee_type = create(:employee_type, attractiveness_bonus: 0.3)
      store = create(:store, employee_type: employee_type)
      stock = build(:stock, store: store, base_price: 100, price: 200, ingredient_count: 0)

      expect(stock.calculate_attractiveness).to eq(0.5 + 0.3)
    end

    it '従業員がいない店舗ではボーナスが加算されない' do
      store = create(:store, employee_type: nil)
      stock = build(:stock, store: store, base_price: 100, price: 200, ingredient_count: 0)

      expect(stock.calculate_attractiveness).to eq(0.5)
    end
  end

  describe '#recalculate_attractiveness!' do
    it 'attractiveness カラムを再計算結果で更新する' do
      stock = create(:stock, base_price: 150, price: 200, ingredient_count: 1, unsold_count: 1)
      stock.recalculate_attractiveness!
      expect(stock.reload.attractiveness).to eq((150.0 / 200) + 0.1)
    end
  end
end
