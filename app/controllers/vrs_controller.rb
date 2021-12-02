class VrsController < ApplicationController
  before_action :authenticate_user!

  def index
    @vrs = current_user.vrs
  end

  def show
    @vr = current_user.vrs.find(params[:id])
  end

  def new
    @vr = Vr.new
  end

  def create
    @vr = current_user.vrs.new(params.require(:vr).permit(:title, :left, :right))
    ActiveRecord::Base.transaction do
      @vr.save!
      flash[:notice] = "登録しました"
      redirect_to vr_path(@vr)
    end
  rescue => e
    p e
    flash.now[:alert] = "失敗しました"
    render :new
  end

  def destroy
    current_user.vrs.find(params[:id]).destroy
    redirect_to vrs_path
  end
end