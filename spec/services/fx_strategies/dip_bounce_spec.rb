require 'rails_helper'

RSpec.describe FxStrategies::DipBounce do
  describe '.entry_signal?' do
    let(:now) { Time.zone.local(2026, 1, 15, 3, 0, 0) } # 5分足境界・ブロック時間外
    let(:day_open) { 150.0 }
    let(:dipped_price) { day_open - described_class::ENTRY_DIP_YEN }

    it 'upレジームかつ値幅条件を満たせばtrue' do
      expect(described_class.entry_signal?(now, day_open, dipped_price, 'up')).to be true
    end

    it 'downレジームならfalse(trend-following疑惑への対策)' do
      expect(described_class.entry_signal?(now, day_open, dipped_price, 'down')).to be false
    end

    it 'レジーム未取得(nil)ならfalse(安全側のフォールバック)' do
      expect(described_class.entry_signal?(now, day_open, dipped_price, nil)).to be false
    end

    it '値幅条件を満たさなければupレジームでもfalse' do
      expect(described_class.entry_signal?(now, day_open, day_open, 'up')).to be false
    end
  end
end
