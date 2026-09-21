require 'rails_helper'

RSpec.describe 'Store::Towns#market', type: :request do
  let(:user)           { create(:user) }
  let(:town)           { create(:town, owner: user) }
  let(:store_category) { create(:store_category) }
  let(:item_category)  { create(:item_category) }
  let(:item_sub_category) { create(:item_sub_category, item_category: item_category) }
  let(:market_cat) { StoreCategory.find_or_create_by!(name: '卸市場') }
  let!(:market_store) do
    town.stores.create!(name: '中央卸売市場', user: nil, store_category: market_cat,
                         theme_color: '#111111', theme_sub_color: '#222222')
  end
  let!(:stock) do
    market_store.stocks.create!(name: 'かぼちゃ', user: nil, item_sub_category: item_sub_category,
                                 cost: 0, base_price: 120, price: 100)
  end

  before do
    UserTown.create!(user: user, town: town)
    user.update!(town: town)
    create(:store, user: user, town: town, store_category: store_category)
    sign_in user
  end

  describe 'GET /store/towns/:id/market' do
    it '200 を返す' do
      get market_store_town_path(town)
      expect(response).to have_http_status(:ok)
    end

    it '基本料金と仕入れ値の両方が表示される' do
      get market_store_town_path(town)
      expect(response.body).to include('基本料金')
      expect(response.body).to include('120円')
      expect(response.body).to include('100円')
    end
  end

  describe '仕入れ値の色分け' do
    let(:cheap_sub)     { create(:item_sub_category, item_category: item_category) }
    let(:expensive_sub) { create(:item_sub_category, item_category: item_category) }
    let(:normal_sub)    { create(:item_sub_category, item_category: item_category) }

    let!(:cheap_stock) do
      # base_price(120) > price(100) → 割安（緑）
      market_store.stocks.create!(name: '割安商品', user: nil, item_sub_category: cheap_sub,
                                   cost: 0, base_price: 120, price: 100)
    end
    let!(:expensive_stock) do
      # base_price(80) < price(100) → 割高（赤）
      market_store.stocks.create!(name: '割高商品', user: nil, item_sub_category: expensive_sub,
                                   cost: 0, base_price: 80, price: 100)
    end
    let!(:normal_stock) do
      market_store.stocks.create!(name: '通常商品', user: nil, item_sub_category: normal_sub,
                                   cost: 0, base_price: 100, price: 100)
    end

    def row_for(body, name)
      body[/<tr>(?:(?!<tr>).)*?#{Regexp.escape(name)}.*?<\/tr>/m]
    end

    it '仕入れ値が基本料金より安い場合は緑色のセルになる' do
      get market_store_town_path(town)
      expect(row_for(response.body, '割安商品')).to include('text-success')
    end

    it '仕入れ値が基本料金より高い場合は赤色のセルになる' do
      get market_store_town_path(town)
      expect(row_for(response.body, '割高商品')).to include('text-danger')
    end

    it '仕入れ値が基本料金と同じ場合は色を付けない' do
      get market_store_town_path(town)
      row = row_for(response.body, '通常商品')
      expect(row).not_to include('text-success')
      expect(row).not_to include('text-danger')
    end
  end
end
