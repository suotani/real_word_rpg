class Store::StoresController < Store::ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]

  def index
    @stores = current_user.stores.includes(:town, :store_category)
  end

  def show
  end

  def new
    @store = Store.new
    @towns = current_user.towns
    @store_categories = StoreCategory.all
    redirect_to join_request_store_towns_path, alert: "町に参加してください。" if @towns.empty?
  end

  def create
    @store = current_user.stores.build(store_params)
    
    if @store.save
      redirect_to store_dashboard_path, notice: "「#{@store.name}」が作成されました。"
    else
      @towns = current_user.towns
      @store_categories = StoreCategory.all
      flash.now[:alert] = '失敗しました。'
      render :new
    end
  end

  def edit
    @towns = current_user.towns
    @store_categories = StoreCategory.all
  end

  def update
    # TODO: 更新するときは商品は空の状態のみ
    if @store.update(store_params)
      redirect_to store_store_path(@store), notice: '更新されました。'
    else
      @towns = current_user.towns
      @store_categories = StoreCategory.all
      render :edit
    end
  end

  private

  def set_store
    @store = current_user.stores.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name, :town_id, :store_category_id, :theme_color, :theme_sub_color)
  end
end 