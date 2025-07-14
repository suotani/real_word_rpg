class Store::TownsController < Store::ApplicationController
  before_action :authenticate_user!
  before_action :set_town, only: [:show, :edit, :update, :destroy]

  def index
    @towns = Town.all
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
      UserTown.create!(user: current_user, town: @town)
    end
    redirect_to store_dashboard_path(@town), notice: "町「#{@town.name}」が作成されました。パスワード: #{@town.password}"
  rescue => e
    flash.now[:alert] = '町の作成に失敗しました。'
    render :new
  end

  def join_request
  end

  def join
    @town = Town.find_by(name: params[:name], password: params[:password])
    if @town && @town.users.exclude?(current_user) && UserTown.create(user: current_user, town: @town)
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
    @town = Town.find(params[:id])
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
