require 'rails_helper'

RSpec.describe FxTrendRegimeService do
  describe '.compute' do
    it 'RSI(14)>=50(上昇基調)なら up を返す' do
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return(rising_closes(30))

      expect(described_class.compute).to eq('up')
    end

    it 'RSI(14)<50(下落基調)なら down を返す' do
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return(falling_closes(30))

      expect(described_class.compute).to eq('down')
    end

    it '15本(RSI(14)に必要な本数)に満たない場合はnilを返す' do
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return(rising_closes(14))

      expect(described_class.compute).to be_nil
    end
  end

  describe '.current' do
    it '新しい計算結果が無い場合、計算してFxMarketRegimeに保存する' do
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return(rising_closes(30))

      expect { described_class.current }.to change(FxMarketRegime, :count).by(1)
      expect(FxMarketRegime.latest.trend).to eq('up')
    end

    it 'max_age以内にキャッシュがあれば再計算せずそれを返す' do
      create(:fx_market_regime, trend: 'down', computed_at: 1.minute.ago)

      expect(GmoCoinApi).not_to receive(:get_hourly_closes)
      expect(described_class.current).to eq('down')
    end

    it 'キャッシュがmax_ageより古ければ再計算する' do
      create(:fx_market_regime, trend: 'down', computed_at: 1.hour.ago)
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return(rising_closes(30))

      expect(described_class.current).to eq('up')
    end

    it '再計算できず(本数不足等)前回値も無い場合はnilを返す' do
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return([])

      expect(described_class.current).to be_nil
    end

    it '再計算できないが前回値があれば前回値を返す(安全側のフォールバック)' do
      create(:fx_market_regime, trend: 'up', computed_at: 1.hour.ago)
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return([])

      expect(described_class.current).to eq('up')
    end
  end

  def rising_closes(count, start: 150.0, step: 0.01)
    Array.new(count) { |i| start + i * step }
  end

  def falling_closes(count, start: 150.0, step: 0.01)
    Array.new(count) { |i| start - i * step }
  end
end
