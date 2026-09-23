require 'rails_helper'

RSpec.describe 'Store::Stores#show', type: :request do
  let(:owner) { create(:user) }
  let(:store) { create(:store, user: owner) }

  describe 'オーナー本人の場合' do
    before { sign_in owner }

    it '200 を返す' do
      get store_store_path(store)
      expect(response).to have_http_status(:ok)
    end

    it '従業員カードと雇用リンクが表示される' do
      get store_store_path(store)
      expect(response.body).to include('従業員')
      expect(response.body).to include(store_store_employee_path(store))
    end

    it '雇用中の従業員名が表示される' do
      employee_type = create(:employee_type, name: '看板娘')
      store.update!(employee_type: employee_type)

      get store_store_path(store)
      expect(response.body).to include('看板娘')
    end
  end

  describe '他人の店舗を閲覧する場合' do
    let(:other_user) { create(:user) }

    before { sign_in other_user }

    it '200 を返す' do
      get store_store_path(store)
      expect(response).to have_http_status(:ok)
    end

    it '従業員の雇用リンクは表示されない' do
      get store_store_path(store)
      expect(response.body).not_to include(store_store_employee_path(store))
    end
  end
end
