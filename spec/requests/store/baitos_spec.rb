require 'rails_helper'

RSpec.describe 'Store::Baitos', type: :request do
  let(:user)   { create(:user) }
  let(:store)  { create(:store, user: user) }
  let(:recipe) { create(:recipe, store: store) }

  before { sign_in user }

  describe 'GET /store/stores/:store_id/baitos' do
    it '200 を返す' do
      get store_store_baitos_path(store)
      expect(response).to have_http_status(:ok)
    end

    it '設定済みのバイトが表示される' do
      create(:baito, store: store, recipe: recipe)
      get store_store_baitos_path(store)
      expect(response.body).to include(recipe.name)
    end
  end

  describe 'GET /store/stores/:store_id/baitos/new' do
    it '200 を返す' do
      get new_store_store_baito_path(store)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /store/stores/:store_id/baitos/:id/edit' do
    let!(:baito) { create(:baito, store: store, recipe: recipe) }

    it '200 を返す' do
      get edit_store_store_baito_path(store, baito)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /store/stores/:store_id/baitos' do
    let(:valid_params) { { baito: { recipe_id: recipe.id, quantity: 3, pricing_mode: 'fixed', fixed_price: 200 } } }

    it '作成に成功する' do
      expect {
        post store_store_baitos_path(store), params: valid_params
      }.to change { store.baitos.count }.by(1)
    end

    it '一覧画面にリダイレクトする' do
      post store_store_baitos_path(store), params: valid_params
      expect(response).to redirect_to(store_store_baitos_path(store))
    end

    context '同じレシピで既にバイトが設定されている場合' do
      before { create(:baito, store: store, recipe: recipe) }

      it '作成に失敗する' do
        expect {
          post store_store_baitos_path(store), params: valid_params
        }.not_to change { store.baitos.count }
      end
    end

    context '他店舗のレシピを指定した場合' do
      let(:other_store)  { create(:store, user: user) }
      let(:other_recipe) { create(:recipe, store: other_store) }
      let(:invalid_params) { { baito: { recipe_id: other_recipe.id, quantity: 1, pricing_mode: 'fixed', fixed_price: 100 } } }

      it '作成に失敗する' do
        expect {
          post store_store_baitos_path(store), params: invalid_params
        }.not_to change { Baito.count }
      end
    end
  end

  describe 'POST /store/stores/:store_id/baitos/:id/toggle' do
    let!(:baito) { create(:baito, store: store, recipe: recipe) }

    it '稼働中のバイトを停止できる' do
      post toggle_store_store_baito_path(store, baito)
      expect(baito.reload.active?).to be false
    end

    it '停止中のバイトを再開できる' do
      baito.update!(active: false)
      post toggle_store_store_baito_path(store, baito)
      expect(baito.reload.active?).to be true
    end

    it '一覧画面にリダイレクトする' do
      post toggle_store_store_baito_path(store, baito)
      expect(response).to redirect_to(store_store_baitos_path(store))
    end
  end

  describe 'DELETE /store/stores/:store_id/baitos/:id' do
    let!(:baito) { create(:baito, store: store, recipe: recipe) }

    it '削除される' do
      expect {
        delete store_store_baito_path(store, baito)
      }.to change { store.baitos.count }.by(-1)
    end
  end

  context '他人の店舗の場合' do
    let(:other_user)  { create(:user) }
    let(:other_store) { create(:store, user: other_user) }

    it 'アクセスできない（404）' do
      get store_store_baitos_path(other_store)
      expect(response).to have_http_status(:not_found)
    end
  end
end
