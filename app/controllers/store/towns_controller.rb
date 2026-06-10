class Store::TownsController < Store::ApplicationController
  before_action :set_town, only: [:show, :edit, :update, :destroy, :market]

  def index
    @towns = Town.all
  end

  def select
    @towns = current_user.towns.includes(:stores)
    @current_town = current_user.town
  end

  def show
  end

  def new
    @town = Town.new
  end

  def create
    @town = Town.new(town_params)

    ActiveRecord::Base.transaction do
      @town.save!
      @town.create_central_wholesale_market!
      @town.populate_wholesale_items!
      UserTown.create!(user: current_user, town: @town)
      current_user.update!(town: @town)
    end
    redirect_to store_dashboard_path(@town), notice: "町「#{@town.name}」が作成されました。パスワード: #{@town.password}"
  rescue => e
    flash.now[:alert] = '町の作成に失敗しました。'
    render :new
  end

  def switch
    town = current_user.towns.find(params[:town_id])
    current_user.update!(town: town)
    redirect_back fallback_location: store_root_path, notice: "「#{town.name}」に切り替えました。"
  end

  def market
    @market      = @town.stores.find_by!(user_id: nil, name: '中央卸売市場')
    @user_stores = current_user.stores.where(town: @town)

    stocks = @market.stocks.includes(item_sub_category: :item_category)

    if params[:item_category_id].present?
      stocks = stocks.where(item_sub_categories: { item_category_id: params[:item_category_id] })
    end

    @stocks         = stocks
    @item_categories = ItemCategory.joins(item_sub_categories: :stocks)
                                   .where(stocks: { store_id: @market.id })
                                   .distinct
                                   .order(:name)
  end

  def join_request
  end

  def join
    @town = Town.find_by(name: params[:name], password: params[:password])
    if @town && @town.users.exclude?(current_user) && UserTown.create(user: current_user, town: @town)
      current_user.update!(town: @town)
      redirect_to store_dashboard_path, notice: '町に参加しました。'
    else
      flash.now[:alert] = '町に参加できませんでした。'
      render :join_request
    end
  end

  # def edit
  # end

  # def update
  #   if @town.update(town_params)
  #     redirect_to shop_town_path(@town), notice: '町が正常に更新されました。'
  #   else
  #     render :edit
  #   end
  # end

  private

  def set_town
    @town = current_user.towns.find(params[:id])
  end

  def town_params
    params.require(:town).permit(:name).tap do |town_params|
      town_params[:password] = generate_password
      town_params[:user_id] = current_user.id
    end
  end

  def generate_password
    # 8文字の小文字英数パスワードを生成
    chars = ('a'..'z').to_a + ('0'..'9').to_a
    (0...8).map { chars.sample }.join
  end
end
