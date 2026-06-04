class Store::StocksController < Store::ApplicationController
  before_action :set_store
  before_action :set_stock, only: [:show, :edit, :update, :destroy, :list, :unlist]
  before_action :set_item_sub_categories, only: [:index, :new, :create, :edit, :update]

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

  def list
    if request.post?
      price = params[:price].to_i
      if price > 0
        @stock.update!(price: price, listed: true)
        redirect_to store_store_stocks_path(@store), notice: "「#{@stock.name}」を出品しました。"
      else
        flash.now[:alert] = '販売価格を1円以上で入力してください。'
        render :list
      end
    end
    # GET: list.html.haml を暗黙レンダリング
  end

  def unlist
    @stock.update!(listed: false)
    redirect_to store_store_stocks_path(@store), notice: "「#{@stock.name}」の出品を取り消しました。"
  end

  private

  def set_store
    @store = current_user.stores.find(params[:store_id])
  end

  def set_stock
    @stock = @store.stocks.find(params[:id])
  end

  def set_item_sub_categories
    @item_sub_categories = ItemSubCategory.includes(:item_category).order('item_categories.name, item_sub_categories.name')
  end

  def stock_params
    params.require(:stock).permit(:name, :item_sub_category_id, :cost, :price)
  end
end
