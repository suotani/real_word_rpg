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

  MAX_LOAN = 300_000

  validates :name, presence: true, uniqueness: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  validates :loan_amount, numericality: { greater_than_or_equal_to: 0 }

  def afford?(amount)
    balance >= amount
  end

  def deduct!(amount)
    decrement!(:balance, amount)
  end

  def in_debt?
    loan_amount > 0
  end

  def remaining_loan_capacity
    MAX_LOAN - loan_amount
  end

  def borrow!(amount)
    raise ArgumentError, "借入金額は1円以上を指定してください"           if amount < 1
    raise ArgumentError, "借入可能残枠を超えています（残枠: #{remaining_loan_capacity}円）" if amount > remaining_loan_capacity
    ActiveRecord::Base.transaction do
      increment!(:balance,     amount)
      increment!(:loan_amount, amount)
    end
  end

  def repay!(amount)
    raise ArgumentError, "返済額が借入残高を超えています" if amount > loan_amount
    raise ArgumentError, "残高が不足しています"          unless afford?(amount)
    raise ArgumentError, "返済額は1円以上を指定してください" if amount < 1
    ActiveRecord::Base.transaction do
      deduct!(amount)
      decrement!(:loan_amount, amount)
    end
  end

end
