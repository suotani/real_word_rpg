class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :charactors
  has_many :vrs
  has_many :tickets
  has_many :managed_htmls

  validates :name, presence: true, uniqueness: true

  before_create do
    self.email = "email.#{(User.pluck(:id).max||0) + 1}@example.com"
  end

  def admin?
    true
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
