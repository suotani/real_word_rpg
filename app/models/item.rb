class Item < ApplicationRecord
  belongs_to :town
  belongs_to :user
  belongs_to :item_category
  has_many :stocks, dependent: :destroy
  has_many :materials, dependent: :destroy

  # バリデーション
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }

  # 名前の一意性（同じ町内で同じ名前のアイテムは作成不可）
  validates :name, uniqueness: { scope: [:town_id, :user_id], message: "は既にこの町で使用されています" }
end
