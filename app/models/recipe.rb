class Recipe < ApplicationRecord
  belongs_to :store
  belongs_to :item_sub_category
  has_many :recipe_item_sub_categories, dependent: :destroy
  has_many :item_sub_categories, through: :recipe_item_sub_categories

  validates :name, presence: true
  validates :item_sub_category, presence: true
end
