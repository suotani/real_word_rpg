require 'rails_helper'

RSpec.describe 'Store::Stores#index', type: :request do
  let(:user)  { create(:user) }
  let(:store) { create(:store, user: user) }

  before do
    store
    sign_in user
  end

  it '200 を返す' do
    get store_stores_path
    expect(response).to have_http_status(:ok)
  end

  it '各店舗カードに従業員ページへのリンクがある' do
    get store_stores_path
    expect(response.body).to include(store_store_employee_path(store))
  end
end
