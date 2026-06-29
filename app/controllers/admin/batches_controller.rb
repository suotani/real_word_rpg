class Admin::BatchesController < Admin::ApplicationController
  def market_price_fluctuation
    result = MarketPriceFluctuationService.new.run
    redirect_to admin_wholesale_stocks_path,
                notice: "価格変動バッチを実行しました（#{result[:updated]}件更新）"
  end
end
