class ItemSubCategory < ApplicationRecord
  belongs_to :item_category
  belongs_to :town, optional: true
  has_many :stocks, dependent: :destroy
  has_many :recipe_item_sub_categories, dependent: :destroy
  has_many :recipes, through: :recipe_item_sub_categories

  validates :name, presence: true,
                   uniqueness: { scope: [:town_id, :item_category_id] }

  after_create :add_to_town_wholesale_market

  private

  def add_to_town_wholesale_market
    return if town

    market = Store.central_wholesale_market
    return unless market

    market.stocks.create!(
      name: name,
      user: nil,
      item_sub_category: self,
      cost: 0,
      price: 100
    )
  end
end
