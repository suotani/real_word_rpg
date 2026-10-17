require 'rails_helper'

RSpec.describe BaitoBatchService do
  subject(:service) { described_class.new }

  let(:owner)          { create(:user, balance: 10_000) }
  let(:town)           { create(:town, owner: owner) }
  let(:store_category) { create(:store_category) }
  let(:store)          { create(:store, user: owner, town: town, store_category: store_category) }

  let(:market_cat) { StoreCategory.find_or_create_by!(name: '卸市場') }
  let!(:market) do
    town.stores.create!(name: '中央卸売市場', user: nil, store_category: market_cat,
                         theme_color: '#111111', theme_sub_color: '#222222')
  end

  let(:item_category) { create(:item_category) }
  let(:pumpkin_sub)    { create(:item_sub_category, item_category: item_category) }

  let!(:market_pumpkin) do
    market.stocks.create!(name: 'かぼちゃ', user: nil, item_sub_category: pumpkin_sub,
                           cost: 0, base_price: 100, price: 100)
  end

  let(:recipe) do
    r = create(:recipe, store: store, item_category: item_category)
    r.item_sub_categories = [pumpkin_sub]
    r
  end

  let!(:baito) { create(:baito, store: store, recipe: recipe, quantity: 2, pricing_mode: 'fixed', fixed_price: 500) }

  describe '#run' do
    it '素材を仕入れ、クラフトし、指定数量だけ出品する' do
      service.run
      crafted = store.stocks.where(name: recipe.name, listed: true)
      expect(crafted.count).to eq(2)
      expect(crafted.pluck(:price).uniq).to eq([500])
    end

    it '仕入れ代金（単価100円×2個）が差し引かれる' do
      expect { service.run }.to change { owner.reload.balance }.by(-200)
    end

    it '処理件数1・エラーなしで返る' do
      result = service.run
      expect(result[:processed]).to eq(1)
      expect(result[:errors]).to be_empty
    end

    context '店舗の在庫数が上限(50)に迫っている場合' do
      before { 49.times { create(:stock, store: store, user: owner) } }

      it '残り枠(1個)に数量が絞られる' do
        service.run
        expect(store.stocks.where(name: recipe.name).count).to eq(1)
      end
    end

    context '店舗の在庫数が既に上限(50)に達している場合' do
      before { 50.times { create(:stock, store: store, user: owner) } }

      it '仕入れ・クラフトを行わずスキップする' do
        result = service.run
        expect(result[:skipped]).to eq(1)
        expect(store.stocks.where(name: recipe.name).count).to eq(0)
      end
    end

    context '所持金が不足している場合' do
      before { owner.update!(balance: 0) }

      it 'エラーとして記録される' do
        result = service.run
        expect(result[:errors]).not_to be_empty
      end

      it '店舗の在庫は増えない（仕入れ自体がロールバックされる）' do
        expect { service.run }.not_to change { store.stocks.count }
      end
    end

    context '市場に対応する素材がない場合' do
      before { market_pumpkin.destroy! }

      it 'エラーとして記録される' do
        result = service.run
        expect(result[:errors].first[:message]).to include('市場')
      end
    end

    context '価格設定が倍率(multiplier)の場合' do
      before { baito.update!(pricing_mode: 'multiplier', fixed_price: nil, price_multiplier: 1.5) }

      it '原価(base_price)×倍率の価格で出品される' do
        service.run
        crafted = store.stocks.find_by!(name: recipe.name, listed: true)
        expect(crafted.price).to eq((crafted.base_price * 1.5).round)
      end
    end

    context '従業員による仕入れ割引(10%)がある場合' do
      let(:employee_type) { create(:employee_type, purchase_discount_rate: 0.1) }

      before { store.update!(employee_type: employee_type) }

      it '割引後の単価（90円×2個=180円）が差し引かれる' do
        expect { service.run }.to change { owner.reload.balance }.by(-180)
      end
    end

    context 'バイトが停止中(active: false)の場合' do
      before { baito.update!(active: false) }

      it '仕入れ・クラフト・出品が行われない' do
        expect { service.run }.not_to change { store.stocks.count }
      end

      it '処理件数・スキップ件数ともに0になる' do
        result = service.run
        expect(result[:processed]).to eq(0)
        expect(result[:skipped]).to eq(0)
      end
    end

    context 'バイト設定が複数の店舗にある場合' do
      let(:other_owner) { create(:user, balance: 10_000) }
      let(:other_store) { create(:store, user: other_owner, town: town, store_category: store_category) }
      let(:other_recipe) do
        r = create(:recipe, store: other_store, item_category: item_category)
        r.item_sub_categories = [pumpkin_sub]
        r
      end
      let!(:other_baito) { create(:baito, store: other_store, recipe: other_recipe, quantity: 1, pricing_mode: 'fixed', fixed_price: 400) }

      it '両方の店舗で処理される' do
        result = service.run
        expect(result[:processed]).to eq(2)
        expect(store.stocks.where(name: recipe.name, listed: true).count).to eq(2)
        expect(other_store.stocks.where(name: other_recipe.name, listed: true).count).to eq(1)
      end
    end
  end
end
