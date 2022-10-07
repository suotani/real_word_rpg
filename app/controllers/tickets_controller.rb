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

  def update
  end

  def destroy
    t = current_user.tickets.find(params[:id])
    t.destroy if t.charactors.blank?
    redirect_to tickets_path
  end


  private

  def ticket_params
    params.require(:ticket).permit(:title, :color)
  end
end