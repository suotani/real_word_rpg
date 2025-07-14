class Store < ApplicationRecord
  belongs_to :town
  belongs_to :user
  belongs_to :store_category
  has_many :stocks, dependent: :destroy

  # バリデーション
  validates :name, presence: true, length: { maximum: 255 }
  validates :theme_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "は有効なカラーコード（#RRGGBB）で入力してください" }
  validates :theme_sub_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "は有効なカラーコード（#RRGGBB）で入力してください" }

  # 名前の一意性（同じ町内で同じ名前の店舗は作成不可）
  validates :name, uniqueness: { scope: :town_id, message: "は既にこの町で使用されています" }

  # カスタムバリデーション
  validate :theme_colors_must_be_different

  private

  def theme_colors_must_be_different
    if theme_color.present? && theme_sub_color.present? && theme_color == theme_sub_color
      errors.add(:theme_sub_color, "はテーマカラーと異なる色を選択してください")
    end
  end
end
