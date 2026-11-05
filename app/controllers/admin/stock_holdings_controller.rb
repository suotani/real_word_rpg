class Admin::StockHoldingsController < Admin::ApplicationController
  def index
    @holdings = StockHolding.all
    @latest_prices = @holdings.index_with { |h| YahooFinanceClient.latest_close(h.code) }
  end

  def update
    holding = StockHolding.find(params[:id])
    if holding.update(bought_price: params[:stock_holding][:bought_price])
      redirect_to admin_stock_holdings_path, notice: "#{holding.name}の購入価格を更新しました"
    else
      redirect_to admin_stock_holdings_path, alert: holding.errors.full_messages.join('、')
    end
  end

  def destroy
    holding = StockHolding.find(params[:id])
    holding.destroy
    redirect_to admin_stock_holdings_path, notice: "#{holding.name}の保有登録を削除しました"
  end
end
