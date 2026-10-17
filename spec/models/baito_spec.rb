require 'rails_helper'

RSpec.describe Baito, type: :model do
  let(:store)  { create(:store) }
  let(:recipe) { create(:recipe, store: store) }

  describe 'バリデーション' do
    it '正常な属性では有効' do
      baito = build(:baito, store: store, recipe: recipe, quantity: 3, pricing_mode: 'fixed', fixed_price: 100)
      expect(baito).to be_valid
    end

    it 'quantityが0以下だと無効' do
      baito = build(:baito, store: store, recipe: recipe, quantity: 0)
      expect(baito).to be_invalid
    end

    it 'pricing_modeがfixedの場合、fixed_priceがないと無効' do
      baito = build(:baito, store: store, recipe: recipe, pricing_mode: 'fixed', fixed_price: nil)
      expect(baito).to be_invalid
    end

    it 'pricing_modeがmultiplierの場合、price_multiplierがないと無効' do
      baito = build(:baito, store: store, recipe: recipe, pricing_mode: 'multiplier', fixed_price: nil, price_multiplier: nil)
      expect(baito).to be_invalid
    end

    it 'pricing_modeがmultiplierの場合、fixed_priceがなくても有効' do
      baito = build(:baito, store: store, recipe: recipe, pricing_mode: 'multiplier', fixed_price: nil, price_multiplier: 1.2)
      expect(baito).to be_valid
    end

    it '同じ店舗・同じレシピで2件目は無効' do
      create(:baito, store: store, recipe: recipe)
      duplicate = build(:baito, store: store, recipe: recipe)
      expect(duplicate).to be_invalid
    end

    it '別の店舗のレシピを指定すると無効' do
      other_store  = create(:store)
      other_recipe = create(:recipe, store: other_store)
      baito = build(:baito, store: store, recipe: other_recipe)
      expect(baito).to be_invalid
    end
  end

  describe 'デフォルト値' do
    it '作成時はactiveがtrueになる' do
      baito = create(:baito, store: store, recipe: recipe)
      expect(baito.active?).to be true
    end
  end

  describe '.active スコープ' do
    it '稼働中のバイトのみを返す' do
      active_baito   = create(:baito, store: store, recipe: recipe)
      other_recipe   = create(:recipe, store: store)
      inactive_baito = create(:baito, store: store, recipe: other_recipe, active: false)

      expect(Baito.active).to include(active_baito)
      expect(Baito.active).not_to include(inactive_baito)
    end
  end

  describe '#listing_price_for' do
    let(:stock) { build(:stock, base_price: 200) }

    it 'fixedの場合はfixed_priceを返す' do
      baito = build(:baito, store: store, recipe: recipe, pricing_mode: 'fixed', fixed_price: 500)
      expect(baito.listing_price_for(stock)).to eq(500)
    end

    it 'multiplierの場合はbase_price×倍率を返す' do
      baito = build(:baito, store: store, recipe: recipe, pricing_mode: 'multiplier', fixed_price: nil, price_multiplier: 1.5)
      expect(baito.listing_price_for(stock)).to eq(300)
    end
  end
end
