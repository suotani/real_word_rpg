class Store::StocksController < Store::ApplicationController
  before_action :set_stock, only: [:show, :edit, :update, :destroy]
  before_action :set_items, only: [:index, :new, :create, :edit, :update]

  def index
    @stocks = current_user.stocks
    @stocks = @stocks.where(store: params[:store_id]) if params[:store_id].present?
  end

  def show
  end

  def new
    @stock = Stock.new
  end

  def create
    @stock = current_user.stocks.build(stock_params)
    
    if @stock.save
      redirect_to store_stocks_path, notice: '在庫が正常に作成されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @stock.update(stock_params)
      redirect_to store_stocks_path, notice: '在庫が正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @stock.destroy
    redirect_to store_stocks_path, notice: '在庫が正常に削除されました。'
  end

  private

  def set_stock
    @stock = current_user.stocks.find(params[:id])
  end

  def set_items
    @items = Item.where(user: current_user).order(:name)
  end

  def stock_params
    params.require(:stock).permit(:item_id, :cost, :price)
  end
end
