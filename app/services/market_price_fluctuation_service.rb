class MarketPriceFluctuationService
  STDDEV_RATIO = 0.1
  MIN_PRICE = 1

  def run
    market = Store.central_wholesale_market
    return { updated: 0, errors: [] } unless market

    updated = 0
    errors  = []

    market.stocks.each do |stock|
      new_price = fluctuate(stock.base_price)
      stock.update!(price: new_price)
      updated += 1
    rescue => e
      errors << { stock_id: stock.id, message: e.message }
    end

    { updated: updated, errors: errors }
  end

  private

  def fluctuate(base_price)
    stddev = base_price * STDDEV_RATIO
    noise  = stddev * standard_normal
    [(base_price + noise).round, MIN_PRICE].max
  end

  # Box-Muller変換で標準正規分布(平均0, 分散1)の乱数を1つ生成する
  def standard_normal
    u1 = 1 - rand
    u2 = rand
    Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * Math::PI * u2)
  end
end
