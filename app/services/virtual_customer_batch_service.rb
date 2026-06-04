class VirtualCustomerBatchService
  def run
    count  = 0
    errors = []

    Stock.listed.includes(:user).find_each do |stock|
      ActiveRecord::Base.transaction do
        stock.user&.increment!(:balance, stock.price)
        stock.destroy!
      end
      count += 1
    rescue => e
      Rails.logger.error "[VirtualCustomerBatch] stock_id=#{stock.id} #{e.class}: #{e.message}"
      errors << { stock_id: stock.id, message: e.message }
    end

    Rails.logger.info "[VirtualCustomerBatch] purchased=#{count} errors=#{errors.size}"
    { count: count, errors: errors }
  end
end
