class WholesaleItemRequest < ApplicationRecord
  MAX_PENDING_PER_USER = 3

  belongs_to :user
  belongs_to :item_category

  enum :status, { pending: 'pending', approved: 'approved', rejected: 'rejected' }, default: :pending

  alias_method :approve!, :approved!
  alias_method :reject!,  :rejected!

  validates :name, presence: true
  validates :base_price, numericality: { greater_than: 0 }

  validate :pending_limit_not_exceeded, on: :create

  private

  def pending_limit_not_exceeded
    return unless user

    if user.wholesale_item_requests.pending.count >= MAX_PENDING_PER_USER
      errors.add(:base, "リクエストは同時に#{MAX_PENDING_PER_USER}件までです")
    end
  end
end
