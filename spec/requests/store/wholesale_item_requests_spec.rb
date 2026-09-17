require 'rails_helper'

RSpec.describe 'Store::WholesaleItemRequests', type: :request do
  let(:user)          { create(:user) }
  let(:town)          { create(:town, owner: user) }
  let(:item_category) { create(:item_category) }

  before do
    user.update!(town: town)
    sign_in user
  end

  describe 'GET /store/wholesale_item_requests/new' do
    it '200 を返す' do
      get new_store_wholesale_item_request_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /store/wholesale_item_requests' do
    let(:valid_params) do
      { wholesale_item_request: { item_category_id: item_category.id, name: 'とうもろこし', base_price: 150 } }
    end

    context '有効なパラメータの場合' do
      it 'リクエストが作成される' do
        expect { post store_wholesale_item_requests_path, params: valid_params }
          .to change { user.wholesale_item_requests.count }.by(1)
      end

      it '自分のリクエストとして pending 状態で作成される' do
        post store_wholesale_item_requests_path, params: valid_params
        request = user.wholesale_item_requests.last
        expect(request).to be_pending
        expect(request.name).to eq('とうもろこし')
        expect(request.base_price).to eq(150)
      end

      it 'リダイレクトする' do
        post store_wholesale_item_requests_path, params: valid_params
        expect(response).to redirect_to(market_store_town_path(town))
      end
    end

    context '無効なパラメータの場合' do
      it '商品名がなければ作成されない' do
        expect {
          post store_wholesale_item_requests_path,
               params: { wholesale_item_request: { item_category_id: item_category.id, name: '', base_price: 150 } }
        }.not_to change(WholesaleItemRequest, :count)
      end
    end

    context 'すでに pending が3件ある場合' do
      before { create_list(:wholesale_item_request, 3, user: user) }

      it '4件目は作成されない' do
        expect { post store_wholesale_item_requests_path, params: valid_params }
          .not_to change(WholesaleItemRequest, :count)
      end

      it '422 を返す' do
        post store_wholesale_item_requests_path, params: valid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
