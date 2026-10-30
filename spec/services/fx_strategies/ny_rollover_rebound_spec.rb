require 'rails_helper'

RSpec.describe FxStrategies::NyRolloverRebound do
  describe '.entry_signal?' do
    it '07:05ちょうどでtrue' do
      expect(described_class.entry_signal?(Time.zone.local(2026, 1, 15, 7, 5, 0))).to be true
    end

    it '07:04ではfalse' do
      expect(described_class.entry_signal?(Time.zone.local(2026, 1, 15, 7, 4, 0))).to be false
    end
  end

  describe '.time_exit?' do
    it '08:00ちょうどでtrue' do
      expect(described_class.time_exit?(Time.zone.local(2026, 1, 15, 8, 0, 0))).to be true
    end

    it '08:00より前はfalse' do
      expect(described_class.time_exit?(Time.zone.local(2026, 1, 15, 7, 59, 0))).to be false
    end

    it '08:00より後もtrue(決済判定は以降ずっと成立し続ける)' do
      expect(described_class.time_exit?(Time.zone.local(2026, 1, 15, 9, 0, 0))).to be true
    end
  end
end
