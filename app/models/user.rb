class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # HTMLADMIN
  has_many :charactors
  has_many :vrs
  has_many :tickets
  has_many :managed_htmls

  # SHOP
  has_many :user_towns
  has_many :towns, through: :user_towns
  has_many :stores
  has_many :items
  has_many :stocks

  validates :name, presence: true, uniqueness: true

  def admin?
    true
  end

end
