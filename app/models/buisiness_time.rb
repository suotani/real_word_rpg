class BuisinessTime < ApplicationRecord
  belongs_to :store_category

  validates :sales_at, inclusion: { in: 0..23 }
end
