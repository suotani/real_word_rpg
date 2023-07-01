class ShopsController < ApplicationController
  before_action :authenticate_user!

  def index
    @charactors = current_user.charactors
    @charactor = current_user.charactors.find(params[:charactor_id])
  end

  def create
    ticket = Ticket.find(params[:ticket_id])
    charactor = current_user.charactors.find(params[:charactor_id])
    ActiveRecord::Base.transaction do
      CharactorTicket.create!(ticket_id: params[:ticket_id], charactor_id: params[:charactor_id])
      charactor.update!(shop_point: charactor.shop_point - ticket.point)
      ticket.charactor.update!(shop_point: ticket.charactor.shop_point + ticket.point)
    end
    redirect_to shops_path(charactor_id: params[:charactor_id]), notice: "チケットをかいました"
  end
end
