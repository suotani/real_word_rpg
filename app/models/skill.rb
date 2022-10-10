class Skill < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :category
  has_many :skill_charactors
end
# 使っていない