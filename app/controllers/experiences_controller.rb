class ExperiencesController < ApplicationController
  before_action :authenticate_user!

  def index
    @charactors = current_user.charactors
  end

  def new
    @charactor = Charactor.find(params[:charactor_id])
    @experience = @charactor.experiences.new
  end

  def create
    @charactor = Charactor.find(params[:charactor_id])
    @experience = @charactor.experiences.new(experience_params)
    if @experience.save
      flash[:notice] = "登録しました"
      redirect_to charactor_path(@charactor)
    else
      flash.now[:notice] = "登録に失敗しました"
      render :new
    end
  end


  def edit
    @experience = Experience.find(params[:id])
  end

  def update
    @experience = Experience.find(params[:id])
    if @experience.update(experience_params)
      flash[:notice] = "登録しました"
      redirect_to experiences_path
    else
      flash.now[:notice] = "登録に失敗しました"
      render :edit
    end
  end

  def destroy
    @experience = Experience.find(params[:id])
    @experience.destroy
    redirect_to experiences_path
  end

  private

  def experience_params
    params.require(:experience).permit(:name, :unit, :unit_exp, :category_id, :explanation)
  end
end