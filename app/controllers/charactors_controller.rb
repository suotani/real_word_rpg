class CharactorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @charactors = current_user.charactors
  end


  def show
    @charactor = current_user.charactors.find(params[:id])
  end

  def create
    @charactor = current_user.charactors.new(chara_params)
    if @charactor.save
      flash[:notice] = "キャラクターを登録しました"
      redirect_to charactor_path(@charactor)
    else
      flash[:alert] = "登録に失敗しました"
      redirect_to charactors_path
    end
  end

  private


  def chara_params
    params.require(:charactor).permit(:name)
  end
end