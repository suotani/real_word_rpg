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

    it '④NyRolloverReboundの稼働時間帯(07:05-08:00)はブロックされエントリーしない' do
      blocked_now = Time.zone.local(2026, 1, 15, 7, 30, 0)
      expect(described_class.entry_signal?(blocked_now, day_open, dipped_price, 'up')).to be false
    end
  end

  describe '.forced_handoff?' do
    it '④NyRolloverReboundの稼働時間帯(①の直後、07:05)に入ったら明け渡し決済する' do
      expect(described_class.forced_handoff?(Time.zone.local(2026, 1, 15, 7, 5, 0))).to be true
    end

    it '④の時間帯の終わり(07:59)もまだ明け渡し継続' do
      expect(described_class.forced_handoff?(Time.zone.local(2026, 1, 15, 7, 59, 0))).to be true
    end

    it '④の時間帯が終わった08:00以降はブロックされない' do
      expect(described_class.forced_handoff?(Time.zone.local(2026, 1, 15, 8, 0, 0))).to be false
    end

    it '①②④のいずれにも入っていない時刻(06:49)は明け渡さない' do
      expect(described_class.forced_handoff?(Time.zone.local(2026, 1, 15, 6, 49, 0))).to be false
    end
  end
end
