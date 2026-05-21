class Stock < ApplicationRecord
  belongs_to :store, optional: true
  belongs_to :user, optional: true
  belongs_to :item_sub_category, optional: true

  validates :name, presence: true
end
