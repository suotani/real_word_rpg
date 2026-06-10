class Stock < ApplicationRecord
  INGREDIENT_WEIGHT = 0.1
  UNSOLD_PENALTY    = 0.05

  belongs_to :store, optional: true
  belongs_to :user, optional: true
  belongs_to :item_sub_category, optional: true

  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }, if: :listed?

  scope :listed, -> { where(listed: true) }

  # 魅力度 = (仕入れ値 ÷ 販売価格) + 素材数 × 0.1 - 売れ残り回数 × 0.05
  def calculate_attractiveness
    return 0.0 if price.to_i <= 0

    (cost.to_f / price) + ingredient_count.to_i * INGREDIENT_WEIGHT - unsold_count.to_i * UNSOLD_PENALTY
  end

  def recalculate_attractiveness!
    update!(attractiveness: calculate_attractiveness)
  end
end
