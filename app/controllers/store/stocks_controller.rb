class Store::StocksController < Store::ApplicationController
  before_action :set_store
  before_action :set_stock, only: [:show, :edit, :update, :destroy, :list, :unlist, :toggle_ingredient]

  def index
    @stocks = @store.stocks

    case params[:status]
    when 'listed'   then @stocks = @stocks.where(listed: true)
    when 'unlisted' then @stocks = @stocks.where(listed: false)
    end
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
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @stock.update(stock_params)
      redirect_to store_store_stocks_path(@store), notice: '在庫が正常に更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy
    redirect_to store_store_stocks_path(@store), notice: '在庫が正常に削除されました。'
  end

  def list
    if request.post?
      price = params[:price].to_i
      if price > 0
        @stock.update!(price: price, listed: true)
        @stock.recalculate_attractiveness!
        redirect_to store_store_stocks_path(@store), notice: "「#{@stock.name}」を出品しました。"
      else
        flash.now[:alert] = '販売価格を1円以上で入力してください。'
        render :list
      end
    end
  end

  def unlist
    @stock.update!(listed: false)
    redirect_to store_store_stocks_path(@store), notice: "「#{@stock.name}」の出品を取り消しました。"
  end

  def toggle_ingredient
    @stock.update!(ingredient: !@stock.ingredient?)
    redirect_to store_store_stocks_path(@store)
  end

  private

  def set_store
    @store = current_user.stores.find(params[:store_id])
  end

  def set_stock
    @stock = @store.stocks.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:name, :cost, :price)
  end
end
