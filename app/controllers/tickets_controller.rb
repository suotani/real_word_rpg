class TicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_charactor

  def index
    @tickets = @charactor.items
  end

  def create
    @ticket = @charactor.items.new(ticket_params)
    @ticket.save ? flash[:notice] = "とうろくしました" : flash[:alert] = @ticket.errors.full_messages.join(",")
    redirect_to charactor_tickets_path(charactor_id: @charactor.id)
  end

  def edit
    @ticket = @charactor.items.find(params[:id])
  end

  def update
    @ticket = @charactor.items.find(params[:id])
    if @ticket.update(ticket_params)
      flash[:notice] = "こうしんしました"
      redirect_to charactor_tickets_path(charactor_id: @charactor.id)
    else
      flash.now[:alert] = "しっぱいしました"
      render :edit
    end
  end

  def destroy
    t = @charactor.items.find(params[:id])
    t.destroy
    redirect_to charactor_tickets_path(charactor_id: @charactor.id)
  end

  private

  def ticket_params
    params.require(:ticket).permit(:title, :color, :point)
  end

  def set_charactor
    @charactor = current_user.charactors.find(params[:charactor_id])
  end
end