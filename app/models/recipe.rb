class Recipe < ApplicationRecord
  belongs_to :store
  has_many :recipe_item_sub_categories, dependent: :destroy
  has_many :item_sub_categories, through: :recipe_item_sub_categories

  validates :name, presence: true
end
