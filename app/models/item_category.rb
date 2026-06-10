class ItemCategory < ApplicationRecord
  has_many :item_category_store_categories, dependent: :destroy
  has_many :store_categories, through: :item_category_store_categories
  has_many :item_sub_categories, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
