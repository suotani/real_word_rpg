class CharactorTicketsController < ApplicationController

  def index
    @charactor = current_user.charactors.find(params[:charactor_id])
    @charactor_tickets = @charactor.charactor_tickets.eager_load(:ticket).where(used: false)
  end


  def update
    ct = CharactorTicket.where(charactor_id: params[:charactor_id]).find(params[:id])
    ct.update(used: true)
    redirect_to charactor_charactor_tickets_path(charactor_id: params[:charactor_id])
  end
end