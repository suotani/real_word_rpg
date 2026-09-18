require 'rails_helper'

RSpec.describe 'Admin::WholesaleItemRequests', type: :request do
  let(:admin)          { create(:user, admin: true) }
  let(:requester)      { create(:user) }
  let(:item_category)  { create(:item_category) }

  describe 'GET /admin/wholesale_item_requests' do
    before { sign_in admin }

    it '200 を返す' do
      get admin_wholesale_item_requests_path
      expect(response).to have_http_status(:ok)
    end

    it 'リクエストの内容が表示される' do
      create(:wholesale_item_request, user: requester, item_category: item_category, name: 'とうもろこし')
      get admin_wholesale_item_requests_path
      expect(response.body).to include('とうもろこし', requester.name)
    end

    context '非管理者ユーザーの場合' do
      before { sign_in create(:user, admin: false) }

      it 'root_pathにリダイレクトする' do
        get admin_wholesale_item_requests_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST /admin/wholesale_item_requests/:id/reject' do
    let!(:request_record) { create(:wholesale_item_request, user: requester, item_category: item_category) }

    before { sign_in admin }

    it 'ステータスが rejected になる' do
      post reject_admin_wholesale_item_request_path(request_record)
      expect(request_record.reload).to be_rejected
    end

    it '一覧にリダイレクトする' do
      post reject_admin_wholesale_item_request_path(request_record)
      expect(response).to redirect_to(admin_wholesale_item_requests_path)
    end

    it '却下により保留枠が空く' do
      create_list(:wholesale_item_request, 2, user: requester)
      expect { post reject_admin_wholesale_item_request_path(request_record) }
        .to change { requester.wholesale_item_requests.pending.count }.from(3).to(2)
    end
  end

  let!(:market) do
    cat = StoreCategory.find_or_create_by!(name: '卸市場')
    Store.create!(name: '中央卸売市場', user: nil, store_category: cat, town_id: nil,
                  theme_color: '#111111', theme_sub_color: '#222222')
  end

  describe 'GET /admin/wholesale_stocks/new （リクエストからの遷移）' do
    let!(:request_record) do
      create(:wholesale_item_request, user: requester, item_category: item_category, name: 'とうもろこし', base_price: 250)
    end

    before { sign_in admin }

    it 'リクエスト内容が入力済みで表示される' do
      get new_admin_wholesale_stock_path(wholesale_item_request_id: request_record.id)
      expect(response.body).to include('とうもろこし')
      expect(response.body).to include('value="250"')
    end
  end

  describe 'POST /admin/wholesale_stocks （リクエスト経由の登録）' do
    let!(:request_record) do
      create(:wholesale_item_request, user: requester, item_category: item_category, name: 'とうもろこし', base_price: 250)
    end

    before { sign_in admin }

    it '登録に成功するとリクエストが承認済みになる' do
      post admin_wholesale_stocks_path, params: {
        wholesale_item_request_id: request_record.id,
        item_category_id: item_category.id,
        stock: { name: 'とうもろこし', cost: 0, base_price: 250 }
      }

      expect(request_record.reload).to be_approved
    end

    it '商品が登録される' do
      expect {
        post admin_wholesale_stocks_path, params: {
          wholesale_item_request_id: request_record.id,
          item_category_id: item_category.id,
          stock: { name: 'とうもろこし', cost: 0, base_price: 250 }
        }
      }.to change(Stock, :count).by(1)
    end
  end
end
