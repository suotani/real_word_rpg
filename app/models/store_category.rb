class StoreCategory < ApplicationRecord
  has_many :item_category_store_categories, dependent: :destroy
  has_many :item_categories, through: :item_category_store_categories
  has_many :stores, dependent: :destroy
  has_many :buisiness_times, dependent: :delete_all

  validates :name, presence: true, uniqueness: true
  validate :sales_hours_format

  def parsed_sales_hours
    return [] if sales_hours.blank?
    sales_hours.split(',').map(&:strip).map(&:to_i).select { |h| (0..23).include?(h) }.uniq.sort
  end

  def sync_buisiness_times!
    BuisinessTime.where(store_category: self).delete_all
    parsed_sales_hours.each { |h| buisiness_times.create!(sales_at: h) }
  end

  private

  def sales_hours_format
    return if sales_hours.blank?
    invalid = sales_hours.split(',').map(&:strip).reject { |t| t.match?(/\A\d{1,2}\z/) && (0..23).include?(t.to_i) }
    errors.add(:sales_hours, "に無効な値があります（#{invalid.join(', ')}）。0〜23 の整数をカンマ区切りで入力してください") if invalid.any?
  end
end
