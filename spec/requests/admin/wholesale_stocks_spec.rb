require 'rails_helper'

RSpec.describe 'Admin::WholesaleStocks', type: :request do
  let(:admin)         { create(:user, admin: true) }
  let(:item_category) { create(:item_category) }
  let!(:market) do
    cat = StoreCategory.find_or_create_by!(name: '卸市場')
    Store.create!(name: '中央卸売市場', user: nil, store_category: cat, town_id: nil,
                  theme_color: '#111111', theme_sub_color: '#222222')
  end

  before { sign_in admin }

  describe 'POST /admin/wholesale_stocks' do
    let(:params) do
      {
        item_category_id: item_category.id,
        stock: { name: 'とうもろこし', cost: 0, base_price: 250, sort_key: '001' }
      }
    end

    it '並べ替えキーが保存される' do
      post admin_wholesale_stocks_path, params: params
      stock = market.stocks.find_by!(name: 'とうもろこし')
      expect(stock.sort_key).to eq('001')
    end

    context '既存のサブカテゴリに再登録する場合' do
      it '並べ替えキーが更新される' do
        post admin_wholesale_stocks_path, params: params
        post admin_wholesale_stocks_path, params: params.deep_merge(stock: { sort_key: '999' })

        stock = market.stocks.find_by!(name: 'とうもろこし')
        expect(stock.sort_key).to eq('999')
      end
    end
  end

  describe 'GET /admin/wholesale_stocks/new' do
    it '並べ替えキーの入力欄が表示される' do
      get new_admin_wholesale_stock_path
      expect(response.body).to include('並べ替えキー')
    end
  end
end
