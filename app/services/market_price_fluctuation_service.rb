class MarketPriceFluctuationService
  FLUCTUATION_RANGE = (-5..5)
  MIN_PRICE = 1

  def run
    market = Store.central_wholesale_market
    return { updated: 0, errors: [] } unless market

    updated = 0
    errors  = []

    market.stocks.each do |stock|
      delta     = rand(FLUCTUATION_RANGE)
      new_price = [stock.price + delta, MIN_PRICE].max
      stock.update!(price: new_price)
      updated += 1
    rescue => e
      errors << { stock_id: stock.id, message: e.message }
    end

    { updated: updated, errors: errors }
  end
end
