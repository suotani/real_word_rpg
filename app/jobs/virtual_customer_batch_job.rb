class VirtualCustomerBatchJob < ApplicationJob
  queue_as :default

  def perform
    result = VirtualCustomerBatchService.new.run
    Rails.logger.info "[VirtualCustomerBatchJob] purchased=#{result[:count]} errors=#{result[:errors].size}"
  end
end
