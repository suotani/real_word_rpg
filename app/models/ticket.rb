class Ticket < ApplicationRecord
  belongs_to :user
  has_many :charactor_tickets
  has_many :charactors, through: :charactor_tickets
end
