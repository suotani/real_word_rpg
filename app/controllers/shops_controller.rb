class ShopsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tickets = current_user.tickets
    @charactor = current_user.charactors.find(params[:charactor_id])
  end

  def create
    @tickets = current_user.tickets.find(params[:ticket_id])
    @charactor = current_user.charactors.find(params[:charactor_id])
    CharactorTicket.create(ticket_id: params[:ticket_id], charactor_id: params[:charactor_id])
    @charactor.update(shop_point: @charactor.shop_point - @tickets.point)
    redirect_to shops_path(charactor_id: params[:charactor_id]), notice: "チケットをかいました"
  end
end
