class Recipe < ApplicationRecord
  belongs_to :store
  belongs_to :item_category, optional: true
  has_many :recipe_ingredients, dependent: :destroy

  validates :name, presence: true
end
