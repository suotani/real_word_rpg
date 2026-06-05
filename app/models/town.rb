class Town < ApplicationRecord
  has_one :user, dependent: :destroy
  has_many :stores, dependent: :destroy
  has_many :user_towns, dependent: :destroy
  has_many :users, through: :user_towns

  after_create :create_central_wholesale_market

  # バリデーション
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { message: "は既に使用されています" }

  # カスタムバリデーション
  validate :name_cannot_be_too_short

  private

  def create_central_wholesale_market
    wholesale_category = StoreCategory.find_or_create_by!(name: '卸市場')

    market = stores.create!(
      name: '中央卸売市場',
      user: nil,
      store_category: wholesale_category,
      theme_color: '#2c3e50',
      theme_sub_color: '#e8d5b7'
    )

    ItemSubCategory.find_each do |sub_cat|
      market.stocks.create!(
        name: sub_cat.name,
        user: nil,
        item_sub_category: sub_cat,
        cost: 0,
        price: 100
      )
    end
  end

  def name_cannot_be_too_short
    if name.present? && name.length < 2
      errors.add(:name, "は2文字以上で入力してください")
    end
  end
end
