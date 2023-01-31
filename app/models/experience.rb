class Experience < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :category
  belongs_to :charactor
  has_many :experience_logs

  UNITS = [
    "", "ページ", "回", "個", "つ", "冊", "日","時間",
    "分"
  ]

  validates :name, presence: true
  validates :unit_exp, presence: true
end
