require 'rails_helper'

RSpec.describe 'Store::Employees', type: :request do
  let(:user)  { create(:user, balance: 1000) }
  let(:store) { create(:store, user: user) }

  before { sign_in user }

  describe 'GET /store/stores/:store_id/employee' do
    it '200 を返す' do
      get store_store_employee_path(store)
      expect(response).to have_http_status(:ok)
    end

    it '雇用可能な従業員種別が表示される' do
      create(:employee_type, name: '看板娘')
      get store_store_employee_path(store)
      expect(response.body).to include('看板娘')
    end

    it '従業員種別の説明が表示される' do
      create(:employee_type, name: '看板娘', description: '明るい接客でお店の魅力と客足を伸ばしてくれる人気者。')
      get store_store_employee_path(store)
      expect(response.body).to include('明るい接客でお店の魅力と客足を伸ばしてくれる人気者。')
    end
  end

  describe 'POST /store/stores/:store_id/employee' do
    let(:employee_type) { create(:employee_type, name: '看板娘', hire_cost: 300) }

    it '雇用に成功する' do
      post store_store_employee_path(store), params: { employee_type_id: employee_type.id }
      expect(store.reload.employee_type).to eq(employee_type)
    end

    it '雇用費が差し引かれる' do
      expect { post store_store_employee_path(store), params: { employee_type_id: employee_type.id } }
        .to change { user.reload.balance }.from(1000).to(700)
    end

    it '一覧画面にリダイレクトする' do
      post store_store_employee_path(store), params: { employee_type_id: employee_type.id }
      expect(response).to redirect_to(store_store_employee_path(store))
    end

    context '所持金が不足している場合' do
      let(:expensive_type) { create(:employee_type, hire_cost: 2000) }

      it '雇用されない' do
        post store_store_employee_path(store), params: { employee_type_id: expensive_type.id }
        expect(store.reload.employee_type).to be_nil
      end

      it 'アラートを表示してリダイレクトする' do
        post store_store_employee_path(store), params: { employee_type_id: expensive_type.id }
        expect(response).to redirect_to(store_store_employee_path(store))
        follow_redirect!
        expect(response.body).to include('所持金が不足しています')
      end
    end
  end

  describe 'DELETE /store/stores/:store_id/employee' do
    let(:employee_type) { create(:employee_type, hire_cost: 300) }

    before { store.hire_employee!(user, employee_type) }

    it '解雇される' do
      delete store_store_employee_path(store)
      expect(store.reload.employee_type).to be_nil
    end

    it '無料である（残高が変化しない）' do
      expect { delete store_store_employee_path(store) }.not_to change { user.reload.balance }
    end
  end

  context '他人の店舗の場合' do
    let(:other_user)  { create(:user) }
    let(:other_store) { create(:store, user: other_user) }

    it 'アクセスできない（404）' do
      get store_store_employee_path(other_store)
      expect(response).to have_http_status(:not_found)
    end
  end
end
