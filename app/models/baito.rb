class Baito < ApplicationRecord
  PRICING_MODES = %w[fixed multiplier].freeze

  belongs_to :store
  belongs_to :recipe

  scope :active, -> { where(active: true) }

  validates :quantity, presence: true, numericality: { greater_than: 0, only_integer: true }
  validates :pricing_mode, inclusion: { in: PRICING_MODES }
  validates :fixed_price, presence: true, numericality: { greater_than: 0 }, if: -> { pricing_mode == 'fixed' }
  validates :price_multiplier, presence: true, numericality: { greater_than: 0 }, if: -> { pricing_mode == 'multiplier' }
  validates :recipe_id, uniqueness: { scope: :store_id, message: 'は既にこの店舗でバイト設定済みです' }

  validate :recipe_belongs_to_store

  # バイトで作った商品（stock）の出品価格を決める
  def listing_price_for(stock)
    pricing_mode == 'fixed' ? fixed_price : (stock.base_price * price_multiplier).round
  end

  private

  def recipe_belongs_to_store
    return if recipe.nil? || store.nil?

    errors.add(:recipe, 'はこの店舗のレシピを指定してください') unless recipe.store_id == store_id
  end
end
