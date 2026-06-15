require 'rails_helper'

RSpec.describe WholesaleItemsImporter do
  describe '.import!' do
    context 'town を指定した場合' do
      let(:town) { create(:town) }

      it 'マスタCSVの商品の種類が町に新規作成される' do
        expect { described_class.import!(town: town) }.to change {
          ItemSubCategory.where(town: town).count
        }.from(0)
      end

      it '新規作成件数を返す' do
        count = described_class.import!(town: town)
        expect(count).to eq(ItemSubCategory.where(town: town).count)
        expect(count).to be > 0
      end

      it '2回目の実行では新規作成されない（冪等）' do
        described_class.import!(town: town)
        expect(described_class.import!(town: town)).to eq(0)
      end
    end

    context 'town が nil の場合' do
      it 'ItemSubCategory は作成されず 0 を返す' do
        expect { expect(described_class.import!(town: nil)).to eq(0) }
          .not_to change(ItemSubCategory, :count)
      end
    end
  end
end
