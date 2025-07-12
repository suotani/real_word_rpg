class Town < ApplicationRecord
  has_one :user, dependent: :destroy
  has_many :stores, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :user_towns, dependent: :destroy
  has_many :users, through: :user_towns
end
