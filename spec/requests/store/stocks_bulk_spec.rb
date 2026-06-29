require 'rails_helper'

RSpec.describe 'Store::Stocks まとめて出品', type: :request do
  let(:user)  { create(:user) }
  let(:store) { create(:store, user: user) }

  before { sign_in user }

  describe 'GET /store/stores/:store_id/stocks/bulk_new' do
    context '未出品のstockがある場合' do
      before do
        create(:stock, store: store, user: user, name: 'りんご', listed: false)
        create(:stock, store: store, user: user, name: 'りんご', listed: false)
        create(:stock, store: store, user: user, name: 'みかん', listed: false)
        create(:stock, store: store, user: user, name: 'バナナ', listed: true)
      end

      it '200 を返す' do
        get bulk_new_store_store_stocks_path(store)
        expect(response).to have_http_status(:ok)
      end

      it '未出品のstock名がuniqで表示される' do
        get bulk_new_store_store_stocks_path(store)
        expect(response.body).to include('りんご', 'みかん')
      end

      it '出品済みstock名は表示されない' do
        get bulk_new_store_store_stocks_path(store)
        expect(response.body).not_to include('バナナ')
      end
    end

    context '未出品のstockがない場合' do
      it '200 を返す' do
        get bulk_new_store_store_stocks_path(store)
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET /store/stores/:store_id/stocks/bulk_confirm' do
    before do
      create(:stock, store: store, user: user, name: 'りんご', cost: 80,  listed: false)
      create(:stock, store: store, user: user, name: 'りんご', cost: 100, listed: false)
    end

    it '200 を返す' do
      get bulk_confirm_store_store_stocks_path(store), params: { name: 'りんご' }
      expect(response).to have_http_status(:ok)
    end

    it '商品名と平均コストが表示される' do
      get bulk_confirm_store_store_stocks_path(store), params: { name: 'りんご' }
      expect(response.body).to include('りんご', '90.0')
    end
  end

  describe 'POST /store/stores/:store_id/stocks/bulk_create' do
    let!(:stock1) { create(:stock, store: store, user: user, name: 'りんご', listed: false) }
    let!(:stock2) { create(:stock, store: store, user: user, name: 'りんご', listed: false) }
    let!(:other)  { create(:stock, store: store, user: user, name: 'みかん', listed: false) }

    context '有効な価格が指定された場合' do
      it '同名の未出品stockをすべて出品状態にする' do
        post bulk_create_store_store_stocks_path(store), params: { name: 'りんご', price: 200 }
        expect(stock1.reload.listed).to be true
        expect(stock2.reload.listed).to be true
      end

      it '指定した価格を設定する' do
        post bulk_create_store_store_stocks_path(store), params: { name: 'りんご', price: 200 }
        expect(stock1.reload.price).to eq(200)
        expect(stock2.reload.price).to eq(200)
      end

      it '別名のstockは変更しない' do
        post bulk_create_store_store_stocks_path(store), params: { name: 'りんご', price: 200 }
        expect(other.reload.listed).to be false
      end

      it '在庫一覧にリダイレクトする' do
        post bulk_create_store_store_stocks_path(store), params: { name: 'りんご', price: 200 }
        expect(response).to redirect_to(store_store_stocks_path(store))
      end
    end

    context '価格が0以下の場合' do
      it 'stockを変更しない' do
        post bulk_create_store_store_stocks_path(store), params: { name: 'りんご', price: 0 }
        expect(stock1.reload.listed).to be false
      end

      it '確認画面を再表示する' do
        post bulk_create_store_store_stocks_path(store), params: { name: 'りんご', price: 0 }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
