require 'rails_helper'

RSpec.describe FxTrendRegimeService do
  describe '.compute' do
    it 'SMA50がSMA200以上なら up を返す' do
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return(flat_closes(150.0, count: 200))

      expect(described_class.compute).to eq('up')
    end

    it 'SMA50がSMA200未満なら down を返す' do
      # 直近50本だけ大きく下げる(直近SMAが長期SMAを下回る状態を作る)
      closes = flat_closes(150.0, count: 150) + flat_closes(140.0, count: 50)

      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return(closes)

      expect(described_class.compute).to eq('down')
    end

    it '200本に満たない場合はnilを返す' do
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return(flat_closes(150.0, count: 199))

      expect(described_class.compute).to be_nil
    end
  end

  describe '.current' do
    it '新しい計算結果が無い場合、計算してFxMarketRegimeに保存する' do
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return(flat_closes(150.0, count: 200))

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
      allow(GmoCoinApi).to receive(:get_hourly_closes).and_return(flat_closes(150.0, count: 200))

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

  def flat_closes(price, count:)
    Array.new(count, price)
  end
end
