class Stock < ApplicationRecord
  belongs_to :item
  belongs_to :store, optional: true
  belongs_to :user
end
