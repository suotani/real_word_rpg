class StoreCategory < ApplicationRecord
  has_many :stores, dependent: :destroy
  has_many :item_categories, dependent: :destroy
end
