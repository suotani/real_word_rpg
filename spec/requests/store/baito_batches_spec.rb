require 'rails_helper'

RSpec.describe 'Store::BaitoBatches', type: :request do
  describe 'GET /store/baito_batch' do
    context '管理者の場合' do
      let(:admin) { create(:user, admin: true) }

      before { sign_in admin }

      it '200 を返す' do
        get store_baito_batch_path
        expect(response).to have_http_status(:ok)
      end
    end

    context '管理者でない場合' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'トップページへリダイレクトされる' do
        get store_baito_batch_path
        expect(response).to redirect_to(store_root_path)
      end
    end
  end

  describe 'POST /store/baito_batch' do
    let(:admin) { create(:user, admin: true) }

    before { sign_in admin }

    it 'BaitoBatchServiceを実行し、結果が表示される' do
      service = instance_double(BaitoBatchService, run: { processed: 0, skipped: 0, errors: [] })
      allow(BaitoBatchService).to receive(:new).and_return(service)

      post store_baito_batch_path

      expect(service).to have_received(:run)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('実行結果')
    end
  end
end
