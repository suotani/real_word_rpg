class Town < ApplicationRecord
  has_one :user, dependent: :destroy
  has_many :stores, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :user_towns, dependent: :destroy
  has_many :users, through: :user_towns

  # バリデーション
  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { message: "は既に使用されています" }

  # カスタムバリデーション
  validate :name_cannot_be_too_short

  private

  def name_cannot_be_too_short
    if name.present? && name.length < 2
      errors.add(:name, "は2文字以上で入力してください")
    end
  end
end
