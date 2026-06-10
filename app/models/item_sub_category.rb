class ItemSubCategory < ApplicationRecord
  belongs_to :item_category
  belongs_to :town, optional: true
  has_many :stocks
  has_many :recipe_item_sub_categories, dependent: :destroy
  has_many :recipes, through: :recipe_item_sub_categories

  validates :name, presence: true,
                   uniqueness: { scope: [:town_id, :item_category_id] }

  after_create :add_to_town_wholesale_market

  private

  def add_to_town_wholesale_market
    return unless town

    wholesale_category = StoreCategory.find_by(name: '卸市場')
    return unless wholesale_category

    market = Store.find_by(user_id: nil, store_category: wholesale_category, town: town)
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
