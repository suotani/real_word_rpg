class Stock < ApplicationRecord
  belongs_to :store, optional: true
  belongs_to :user, optional: true
  belongs_to :item_sub_category, optional: true

  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }, if: :listed?

  scope :listed, -> { where(listed: true) }
end
