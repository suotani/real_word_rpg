class BatchLog < ApplicationRecord
  SUMMARY_HOUR = -1

  validates :target_date, presence: true
  validates :hour, presence: true

  scope :hourly, -> { where.not(hour: SUMMARY_HOUR) }
  scope :summary, -> { where(hour: SUMMARY_HOUR) }
  scope :for_date, ->(date) { where(target_date: date) }
end
