class EmployeeType < ApplicationRecord
  has_many :stores, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :hire_cost, numericality: { greater_than_or_equal_to: 0 }
  validates :attractiveness_bonus, numericality: { greater_than_or_equal_to: 0 }
  validates :purchase_discount_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :extra_customer_count, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :bonus_customer_balance_multiplier, numericality: { greater_than_or_equal_to: 0 }
  validates :virtual_sale_bonus_rate, numericality: { greater_than_or_equal_to: 0 }
end
