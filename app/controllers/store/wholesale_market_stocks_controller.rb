class Store::WholesaleMarketStocksController < Store::ApplicationController
  before_action :require_admin!
  before_action :set_market
  before_action :set_stock, only: [:edit, :update, :destroy]

  def index
    @stocks = @market.stocks.order(:name)
  end

  def new
    @stock = @market.stocks.build
  end

  def create
    @stock = @market.stocks.build(stock_params)
    @stock.user = nil

    if @stock.save
      redirect_to store_wholesale_market_stocks_path, notice: "「#{@stock.name}」を追加しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @stock.update(stock_params)
      redirect_to store_wholesale_market_stocks_path, notice: "「#{@stock.name}」を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
    redirect_to store_wholesale_market_stocks_path, notice: '商品を削除しました。'
  end

  private

  def set_market
    @market = Store.central_wholesale_market
    unless @market
      redirect_to store_root_path, alert: '中央卸売市場が存在しません。'
    end
  end

  def set_stock
    @stock = @market.stocks.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, :cost, :price)
  end
end
