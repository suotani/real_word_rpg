class Store < ApplicationRecord
  belongs_to :town, optional: true
  belongs_to :user, optional: true
  belongs_to :store_category
  belongs_to :employee_type, optional: true
  has_many :stocks, dependent: :destroy
  has_many :recipes, dependent: :destroy
  has_many :baitos, dependent: :destroy

  # バリデーション
  validates :name, presence: true, length: { maximum: 255 }
  validates :theme_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "は有効なカラーコード（#RRGGBB）で入力してください" }
  validates :theme_sub_color, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "は有効なカラーコード（#RRGGBB）で入力してください" }

  # 名前の一意性（同じ町内で同じ名前の店舗は作成不可）
  validates :name, uniqueness: { scope: :town_id, message: "は既にこの町で使用されています" }

  def self.central_wholesale_market
    wholesale_category = StoreCategory.find_by(name: '卸市場')
    return nil unless wholesale_category
    find_by(user_id: nil, store_category: wholesale_category, town_id: nil)
  end

  # town専用の中央卸売市場があればそれを、なければグローバルな市場をフォールバックとして返す
  def self.wholesale_market_for(town)
    wholesale_category = StoreCategory.find_by(name: '卸市場')
    return central_wholesale_market unless wholesale_category

    town&.stores&.find_by(store_category: wholesale_category, name: '中央卸売市場') || central_wholesale_market
  end

  # カスタムバリデーション
  validate :theme_colors_must_be_different

  def hire_employee!(user, new_employee_type)
    unless user.afford?(new_employee_type.hire_cost)
      raise ArgumentError, "所持金が不足しています（必要: #{new_employee_type.hire_cost}円 / 所持: #{user.balance}円）"
    end

    ActiveRecord::Base.transaction do
      update!(employee_type: new_employee_type)
      user.deduct!(new_employee_type.hire_cost)
    end
  end

  def dismiss_employee!
    update!(employee_type: nil)
  end

  private

  def theme_colors_must_be_different
    if theme_color.present? && theme_sub_color.present? && theme_color == theme_sub_color
      errors.add(:theme_sub_color, "はテーマカラーと異なる色を選択してください")
    end
  end
end
