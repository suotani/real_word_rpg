class VirtualCustomerBatchService
  # 出品中の商品をランダムに仮想購入する
  def run
    count = 0
    errors = []

    Stock.listed.includes(:store, :user).find_each do |stock|
      next if rand > purchase_probability

      purchase(stock)
      count += 1
    rescue => e
      Rails.logger.error "[VirtualCustomerBatch] stock_id=#{stock.id} #{e.class}: #{e.message}"
      errors << { stock_id: stock.id, message: e.message }
    end

    { count: count, errors: errors }
  end

  private

  PURCHASE_PROBABILITY = 0.3

  # 出品中の商品が1回のバッチで購入される確率（調整可）
  def purchase_probability
    self.class::PURCHASE_PROBABILITY
  end

  def purchase(stock)
    seller = stock.user
    price  = stock.price

    ActiveRecord::Base.transaction do
      stock.destroy!
      seller&.increment!(:balance, price)
    end
  end
end
