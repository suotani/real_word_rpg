class Store::StoresController < Store::ApplicationController
  before_action :set_store,          only: [:edit, :update, :destroy]
  before_action :set_store_for_show, only: [:show]

  def index
    stores = current_user.stores.includes(:town, :store_category, :stocks)
    active_town = current_user.town
    @stores_by_town = stores.group_by(&:town).sort_by do |town, _|
      town == active_town ? 0 : 1
    end
  end

  def show
    @listed_stocks = @store.stocks.listed.includes(:item_sub_category)
    @is_owner      = @store.user_id == current_user.id
  end

  def new
    current_town = current_user.town
    redirect_to select_store_towns_path, alert: "先に街を選択してください。" and return unless current_town
    @store = Store.new
    @store_categories = StoreCategory.where.not(name: '卸市場')
  end

  def create
    @store = current_user.stores.build(store_params)
    @store.town = current_user.town
    @store_categories = StoreCategory.where.not(name: '卸市場')

    listing_fee = @store.store_category&.listing_fee.to_i
    unless current_user.afford?(listing_fee)
      flash.now[:alert] = "所持金が不足しています。出店料: #{listing_fee}円 / 所持: #{current_user.balance}円"
      render :new and return
    end

    ActiveRecord::Base.transaction do
      @store.save!
      current_user.deduct!(listing_fee)
    end
    redirect_to store_dashboard_path, notice: "「#{@store.name}」が作成されました。（出店料: #{listing_fee}円）"
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = '失敗しました。'
    render :new
  end

  def edit
    @store_categories = StoreCategory.where.not(name: '卸市場')
  end

  def update
    # TODO: 更新するときは商品は空の状態のみ
    if @store.update(store_params)
      redirect_to store_store_path(@store), notice: '更新されました。'
    else
      @store_categories = StoreCategory.where.not(name: '卸市場')
      render :edit
    end
  end

  private

  def set_store
    @store = current_user.stores.find(params[:id])
  end

  def set_store_for_show
    @store = Store.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name, :store_category_id, :theme_color, :theme_sub_color)
  end
end 