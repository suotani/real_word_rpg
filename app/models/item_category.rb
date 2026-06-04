class ItemCategory < ApplicationRecord
  belongs_to :store_category
  has_many :item_sub_categories, dependent: :destroy
  has_many :buisiness_times
end
