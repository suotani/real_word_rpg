require 'rails_helper'

RSpec.describe FxStrategies do
  describe '.stop_loss_hit?' do
    context 'SELL(ショート)' do
      it '価格が entry + stop_loss_yen 以上に上昇したらtrue' do
        expect(described_class.stop_loss_hit?('SELL', 150.0, 150.15, 0.15)).to be true
      end

      it '上昇幅がstop_loss_yen未満ならfalse' do
        expect(described_class.stop_loss_hit?('SELL', 150.0, 150.1, 0.15)).to be false
      end

      it '価格が下がった場合はfalse(ショートにとって有利方向)' do
        expect(described_class.stop_loss_hit?('SELL', 150.0, 149.0, 0.15)).to be false
      end
    end

    context 'BUY(ロング)' do
      it '価格が entry - stop_loss_yen 以下に下落したらtrue' do
        expect(described_class.stop_loss_hit?('BUY', 150.0, 149.85, 0.15)).to be true
      end

      it '下落幅がstop_loss_yen未満ならfalse' do
        expect(described_class.stop_loss_hit?('BUY', 150.0, 149.9, 0.15)).to be false
      end

      it '価格が上がった場合はfalse(ロングにとって有利方向)' do
        expect(described_class.stop_loss_hit?('BUY', 150.0, 151.0, 0.15)).to be false
      end
    end
  end
end
