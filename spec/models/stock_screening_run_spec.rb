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

  describe '.latest_sell_threshold_price' do
    it '最新のRunに含まれる値を返す(古いRunより優先)' do
      described_class.create!(
        generated_at: 2.days.ago,
        result_data: { 'candidates' => [{ 'code' => '6526', 'sell_threshold_price' => 2000.0 }] }
      )
      described_class.create!(
        generated_at: 1.day.ago,
        result_data: { 'candidates' => [{ 'code' => '6526', 'sell_threshold_price' => 2200.0 }] }
      )

      expect(described_class.latest_sell_threshold_price('6526')).to eq(2200.0)
    end

    it '最新のRunに該当コードが無ければ、それより古いRunから探す' do
      described_class.create!(
        generated_at: 2.days.ago,
        result_data: { 'excluded_value_traps' => [{ 'code' => '7201', 'sell_threshold_price' => 600.0 }] }
      )
      described_class.create!(
        generated_at: 1.day.ago,
        result_data: { 'candidates' => [{ 'code' => '6526', 'sell_threshold_price' => 2200.0 }] }
      )

      expect(described_class.latest_sell_threshold_price('7201')).to eq(600.0)
    end

    it 'どのRunにも該当コードが無ければnil' do
      expect(described_class.latest_sell_threshold_price('9999')).to be_nil
    end
  end
end
