require 'rails_helper'

RSpec.describe 'Store::StoreActions#buy', type: :request do
  let(:user)  { create(:user, balance: 1000) }
  let(:town)  { create(:town, owner: user) }
  let(:store) { create(:store, user: user, town: town) }
  let(:target_stock) do
    create(:stock, store: nil, user: nil, item_sub_category: nil, name: 'かぼちゃ', price: 100, base_price: 100, cost: 0)
  end

  before do
    UserTown.create!(user: user, town: town)
    user.update!(town: town)
    sign_in user
  end

  describe 'POST /store/store_actions/buy' do
    context '仕入れ先店舗に従業員がいない場合' do
      it '通常単価で仕入れる' do
        post buy_store_store_actions_path, params: { stock_id: target_stock.id, store_id: store.id, quantity: 1 }
        new_stock = store.stocks.find_by!(name: 'かぼちゃ')
        expect(new_stock.cost).to eq(100)
      end

      it '支払い総額は単価×数量になる' do
        expect {
          post buy_store_store_actions_path, params: { stock_id: target_stock.id, store_id: store.id, quantity: 2 }
        }.to change { user.reload.balance }.from(1000).to(800)
      end
    end

    context '仕入れ先店舗にせり人（仕入れ割引3%）がいる場合' do
      let(:employee_type) { create(:employee_type, purchase_discount_rate: 0.03) }

      before { store.update!(employee_type: employee_type) }

      it '割引後の単価で仕入れる（100円 × 0.97 = 97円）' do
        post buy_store_store_actions_path, params: { stock_id: target_stock.id, store_id: store.id, quantity: 1 }
        new_stock = store.stocks.find_by!(name: 'かぼちゃ')
        expect(new_stock.cost).to eq(97)
        expect(new_stock.base_price).to eq(97)
        expect(new_stock.price).to eq(97)
      end

      it '支払い総額も割引後の単価ベースになる' do
        expect {
          post buy_store_store_actions_path, params: { stock_id: target_stock.id, store_id: store.id, quantity: 2 }
        }.to change { user.reload.balance }.from(1000).to(1000 - 97 * 2)
      end
    end
  end
end
