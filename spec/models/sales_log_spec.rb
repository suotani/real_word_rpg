require 'rails_helper'

RSpec.describe SalesLog do
  let(:user) { create(:user) }

  describe '.record_sale!' do
    context '同じ日に初めて売れた場合' do
      it '当日分のレコードが新規作成される' do
        expect { described_class.record_sale!(user, 100, 60) }.to change(described_class, :count).by(1)

        log = described_class.find_by(user: user, target_date: Date.current)
        expect(log.sales_count).to eq(1)
        expect(log.sales_amount).to eq(100)
        expect(log.cost_amount).to eq(60)
      end
    end

    context '同じ日に複数回売れた場合' do
      it '件数・金額・コストが積み上がる' do
        described_class.record_sale!(user, 100, 60)
        described_class.record_sale!(user, 200, 50)

        log = described_class.find_by(user: user, target_date: Date.current)
        expect(log.sales_count).to eq(2)
        expect(log.sales_amount).to eq(300)
        expect(log.cost_amount).to eq(110)
      end

      it 'レコードは増えない' do
        described_class.record_sale!(user, 100, 60)
        expect { described_class.record_sale!(user, 200, 50) }.not_to change(described_class, :count)
      end
    end

    context 'user が nil の場合' do
      it '何もしない' do
        expect { described_class.record_sale!(nil, 100, 60) }.not_to change(described_class, :count)
      end
    end
  end

  describe '#profit_amount' do
    it '売上金額からコストを引いた値になる' do
      log = build(:sales_log, sales_amount: 300, cost_amount: 110)
      expect(log.profit_amount).to eq(190)
    end
  end
end
