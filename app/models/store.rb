class Store < ApplicationRecord
  belongs_to :town
  belongs_to :user
  belongs_to :store_category
  has_many :stocks, dependent: :destroy
end
