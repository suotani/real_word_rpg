class Store::WholesaleItemRequestsController < Store::ApplicationController
  def new
    @wholesale_item_request = WholesaleItemRequest.new
    @item_categories = ItemCategory.order(:name)
  end

  def create
    @wholesale_item_request = current_user.wholesale_item_requests.new(wholesale_item_request_params)

    if @wholesale_item_request.save
      redirect_to market_store_town_path(current_user.town), notice: '商品登録リクエストを送信しました。'
    else
      @item_categories = ItemCategory.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def wholesale_item_request_params
    params.require(:wholesale_item_request).permit(:item_category_id, :name, :base_price)
  end
end
