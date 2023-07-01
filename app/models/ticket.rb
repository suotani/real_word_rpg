class Ticket < ApplicationRecord
  has_many :charactor_tickets, dependent: :destroy
  has_many :charactors, through: :charactor_tickets
  belongs_to :charactor

  validate :count_under_5

  def count_under_5
    return if Ticket.where(charactor_id: charactor.id).count <= 4

    errors.add(:base, "チケットは５つまでしかつくれないよ")
  end
end
