class Store::StocksController < Store::ApplicationController
  before_action :set_store
  before_action :set_stock, only: [:show, :edit, :update, :destroy]
  before_action :set_items, only: [:index, :new, :create, :edit, :update]

  def index
    @stocks = @store.stocks
  end

  def show
  end

  def new
    @stock = @store.stocks.build
  end

  def create
    @stock = @store.stocks.build(stock_params)
    @stock.user = current_user

    if @stock.save
      redirect_to store_store_stocks_path(@store), notice: '在庫が正常に作成されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @stock.update(stock_params)
      redirect_to store_store_stocks_path(@store), notice: '在庫が正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @stock.destroy
    redirect_to store_store_stocks_path(@store), notice: '在庫が正常に削除されました。'
  end

  private

  def set_store
    @store = current_user.stores.find(params[:store_id])
  end

  def set_stock
    @stock = @store.stocks.find(params[:id])
  end

  def set_items
    @items = @store.items.order(:name)
  end

  def stock_params
    params.require(:stock).permit(:item_id, :cost, :price)
  end
end
