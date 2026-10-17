class Recipe < ApplicationRecord
  class InsufficientIngredientsError < StandardError; end

  belongs_to :store
  belongs_to :item_category
  has_many :recipe_item_sub_categories, dependent: :destroy
  has_many :item_sub_categories, through: :recipe_item_sub_categories
  has_many :baitos, dependent: :destroy

  validates :name, presence: true

  # store の在庫から素材を消費して quantity 個クラフトする。消費した素材の cost/base_price の合計が
  # 完成品のcost/base_priceになる（Store::RecipesController#craft, BaitoBatchService から利用）。
  def craft!(store:, user:, quantity:)
    ingredient_ids = item_sub_categories.pluck(:id)
    raise InsufficientIngredientsError, '素材が設定されていません' if ingredient_ids.empty?

    stocks_by_ingredient = ingredient_ids.index_with { |id| store.stocks.where(item_sub_category_id: id).to_a }
    max_quantity = stocks_by_ingredient.values.map(&:size).min
    raise InsufficientIngredientsError, '素材が不足しています' if max_quantity < quantity

    created = []
    ActiveRecord::Base.transaction do
      quantity.times do |i|
        batch_stocks = ingredient_ids.map { |id| stocks_by_ingredient[id][i] }
        total_cost = batch_stocks.sum(&:cost)
        total_base_price = batch_stocks.sum(&:base_price)
        batch_stocks.each(&:destroy!)
        created << store.stocks.create!(
          name: name,
          cost: total_cost,
          base_price: total_base_price,
          price: 0,
          user: user,
          ingredient_count: batch_stocks.size
        )
      end
    end
    created
  end
end
