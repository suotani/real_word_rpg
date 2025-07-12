class ItemCategory < ApplicationRecord
  belongs_to :store_category
  has_many :items, dependent: :destroy
  has_many :buisiness_times
end
