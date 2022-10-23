class TicketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tickets = current_user.tickets
  end

  def create
    @ticket = current_user.tickets.new(ticket_params)
    @ticket.save ? flash[:notice] = "登録しました" : flash[:alert] = "失敗しました"
    redirect_to tickets_path
  end

  def edit
    @ticket = current_user.tickets.find(params[:id])
  end

  def update
    @ticket = current_user.tickets.find(params[:id])
    if @ticket.update(ticket_params)
      flash[:notice] = "更新しました"
      redirect_to tickets_path
    else
      flash.now[:alert] = "失敗しました"
      render :edit
    end
  end

  def destroy
    t = current_user.tickets.find(params[:id])
    t.destroy if t.charactors.blank?
    redirect_to tickets_path
  end

  private

  def ticket_params
    params.require(:ticket).permit(:title, :color, :point)
  end
end