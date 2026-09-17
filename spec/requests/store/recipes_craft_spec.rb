require 'rails_helper'

RSpec.describe 'Store::Recipes クラフト', type: :request do
  let(:user)          { create(:user) }
  let(:store)         { create(:store, user: user) }
  let(:item_category) { create(:item_category) }
  let(:pumpkin_sub)    { create(:item_sub_category, item_category: item_category) }
  let(:onion_sub)      { create(:item_sub_category, item_category: item_category) }

  let(:recipe) do
    recipe = create(:recipe, store: store, item_category: item_category)
    recipe.item_sub_categories = [pumpkin_sub, onion_sub]
    recipe
  end

  let!(:pumpkin_stock) do
    create(:stock, store: store, user: user, item_sub_category: pumpkin_sub,
                    name: 'かぼちゃ', cost: 100, base_price: 80, price: 0, listed: false)
  end
  let!(:onion_stock) do
    create(:stock, store: store, user: user, item_sub_category: onion_sub,
                    name: 'たまねぎ', cost: 50, base_price: 40, price: 0, listed: false)
  end

  before { sign_in user }

  describe 'POST /store/stores/:store_id/recipes/:id/craft' do
    it '材料の基本料金の合計が作った商品の基本料金になる' do
      post craft_store_store_recipe_path(store, recipe), params: { quantity: 1 }

      crafted = store.stocks.find_by!(name: recipe.name)
      expect(crafted.base_price).to eq(80 + 40)
    end

    it '材料の仕入れ値（cost）の合計が作った商品のcostになる' do
      post craft_store_store_recipe_path(store, recipe), params: { quantity: 1 }

      crafted = store.stocks.find_by!(name: recipe.name)
      expect(crafted.cost).to eq(100 + 50)
    end

    it '消費した材料の在庫が削除される' do
      post craft_store_store_recipe_path(store, recipe), params: { quantity: 1 }

      expect(Stock.exists?(pumpkin_stock.id)).to be false
      expect(Stock.exists?(onion_stock.id)).to be false
    end
  end
end
