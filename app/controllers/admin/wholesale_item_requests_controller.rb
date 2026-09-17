class Admin::WholesaleItemRequestsController < Admin::ApplicationController
  before_action :set_request, only: [:reject]

  def index
    @requests = WholesaleItemRequest.includes(:user, :item_category).order(created_at: :desc)
  end

  def reject
    @request.reject!
    redirect_to admin_wholesale_item_requests_path, notice: "「#{@request.name}」のリクエストを却下しました。"
  end

  private

  def set_request
    @request = WholesaleItemRequest.find(params[:id])
  end
end
