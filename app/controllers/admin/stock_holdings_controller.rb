class Admin::StockHoldingsController < Admin::ApplicationController
  def index
    @holdings = StockHolding.all
    @latest_prices = @holdings.index_with { |h| YahooFinanceClient.latest_close(h.code) }
  end

  def destroy
    holding = StockHolding.find(params[:id])
    holding.destroy
    redirect_to admin_stock_holdings_path, notice: "#{holding.name}の保有登録を削除しました"
  end
end
