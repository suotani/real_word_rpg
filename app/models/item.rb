class Item < ApplicationRecord
  belongs_to :town
  belongs_to :user
  belongs_to :item_category
  has_many :stocks, dependent: :destroy
  has_many :materials, dependent: :destroy
end
