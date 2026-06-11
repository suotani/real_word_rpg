class SalesLog < ApplicationRecord
  belongs_to :user

  validates :target_date, presence: true
  validates :sales_count, numericality: { greater_than_or_equal_to: 0 }
  validates :sales_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :cost_amount, numericality: { greater_than_or_equal_to: 0 }

  def self.record_sale!(user, price, cost)
    return unless user

    log = find_or_create_by!(user: user, target_date: Date.current)
    log.sales_count  += 1
    log.sales_amount += price
    log.cost_amount  += cost
    log.save!
  end

  def profit_amount
    sales_amount - cost_amount
  end
end
