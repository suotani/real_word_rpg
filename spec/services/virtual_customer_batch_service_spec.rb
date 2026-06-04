require 'rails_helper'

RSpec.describe VirtualCustomerBatchService do
  subject(:service) { described_class.new }

  let(:seller) { create(:user, balance: 0) }
  let(:store)  { create(:store, user: seller) }

  before { stub_const('VirtualCustomerBatchService::PURCHASE_PROBABILITY', 1.0) }

  describe '#run' do
    context '出品中の商品がある場合' do
      let!(:pumpkin) { create(:stock, :listed, name: 'かぼちゃ', price: 200, cost: 100, store: store, user: seller) }
      let!(:onion)   { create(:stock, :listed, name: 'たまねぎ', price: 150, cost:  80, store: store, user: seller) }

      it '出品中の全商品を購入し count を返す' do
        result = service.run
        expect(result[:count]).to eq(2)
        expect(result[:errors]).to be_empty
      end

      it '購入された商品の代金が売り手の残高に加算される' do
        service.run
        expect(seller.reload.balance).to eq(200 + 150)
      end

      it '購入された stock レコードが削除される' do
        expect { service.run }.to change(Stock, :count).by(-2)
      end
    end

    context '確率を 0 に固定した場合' do
      before { stub_const('VirtualCustomerBatchService::PURCHASE_PROBABILITY', 0.0) }

      let!(:stock) { create(:stock, :listed, store: store, user: seller) }

      it '何も購入されない' do
        result = service.run
        expect(result[:count]).to eq(0)
        expect(Stock.count).to eq(1)
      end
    end

    context '未出品の商品のみの場合' do
      let!(:stock) { create(:stock, store: store, user: seller) }

      it '購入対象にならない' do
        result = service.run
        expect(result[:count]).to eq(0)
        expect(Stock.count).to eq(1)
      end
    end

    context '出品中の商品が 0 件の場合' do
      it 'count: 0 で正常終了する' do
        result = service.run
        expect(result[:count]).to eq(0)
        expect(result[:errors]).to be_empty
      end
    end
  end
end
