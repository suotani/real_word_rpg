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
  belongs_to :town, optional: true
  has_many :user_towns
  has_many :towns, through: :user_towns
  has_many :stores
  has_many :stocks

  validates :name, presence: true, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def afford?(amount)
    balance >= amount
  end

  def deduct!(amount)
    decrement!(:balance, amount)
  end

  def admin?
    true
  end

end
