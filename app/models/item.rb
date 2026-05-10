class Item < ApplicationRecord
  belongs_to :town
  belongs_to :store
  belongs_to :item_category
  has_many :stocks, dependent: :destroy
  has_many :materials, dependent: :destroy
  has_many :recipe_materials, class_name: 'Material', foreign_key: :recipe_id, dependent: :destroy

  accepts_nested_attributes_for :recipe_materials, allow_destroy: true, reject_if: :all_blank

  # バリデーション
  validates :name, presence: true, length: { maximum: 255 }

  # 名前の一意性（同じ町内で同じ名前のアイテムは作成不可）
  validates :name, uniqueness: { scope: [:town_id, :store_id], message: "は既にこの町で使用されています" }
end
