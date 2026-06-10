class VirtualCustomerBatchJob < ApplicationJob
  queue_as :default

  def perform
    result = VirtualCustomerBatchService.new.run
    Rails.logger.info "[VirtualCustomerBatchJob] hour=#{Time.current.hour} purchased=#{result[:count]} total=#{result[:total_amount]} errors=#{result[:errors].size}"
  end
end
