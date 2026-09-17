require 'rails_helper'

RSpec.describe 'Store::Stocks 出品', type: :request do
  let(:user)  { create(:user) }
  let(:store) { create(:store, user: user) }
  let!(:stock) { create(:stock, store: store, user: user, base_price: 80, price: 100, listed: false) }

  before { sign_in user }

  describe 'POST /store/stores/:store_id/stocks/:id/list' do
    context '有効な価格が指定された場合' do
      it '販売価格を設定し出品状態にする' do
        post list_store_store_stock_path(store, stock), params: { price: 500 }
        stock.reload
        expect(stock.listed).to be true
        expect(stock.price).to eq(500)
      end

      it '基本料金（base_price）は上書きしない' do
        expect { post list_store_store_stock_path(store, stock), params: { price: 500 } }
          .not_to(change { stock.reload.base_price })
      end

      it '魅力度が基本料金ベースで再計算される' do
        post list_store_store_stock_path(store, stock), params: { price: 500 }
        expect(stock.reload.attractiveness).to eq(80.0 / 500)
      end
    end

    context '価格が0以下の場合' do
      it '出品状態にしない' do
        post list_store_store_stock_path(store, stock), params: { price: 0 }
        expect(stock.reload.listed).to be false
      end
    end
  end
end
