class ItemSubCategory < ApplicationRecord
  belongs_to :item_category
  has_many :stocks
  has_many :recipe_item_sub_categories, dependent: :destroy
  has_many :recipes, through: :recipe_item_sub_categories

  validates :name, presence: true
end
