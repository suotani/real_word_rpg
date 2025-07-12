class Shop::TownsController < ApplicationController
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
    
    if @town.save
      redirect_to shop_town_path(@town), notice: '町が正常に作成されました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @town.update(town_params)
      redirect_to shop_town_path(@town), notice: '町が正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @town.destroy
    redirect_to shop_towns_path, notice: '町が削除されました。'
  end

  private

  def set_town
    @town = Town.find(params[:id])
  end

  def town_params
    params.require(:town).permit(:name)
  end
end
