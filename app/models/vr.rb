class Vr < ApplicationRecord
  has_one_attached :left
  has_one_attached :right

  belongs_to :user
end
