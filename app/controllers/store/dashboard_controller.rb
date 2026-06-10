class Store::DashboardController < Store::ApplicationController
  def index
    @current_town = current_user.town
    if @current_town
      @current_town = Town.includes(stores: [{ store_category: :buisiness_times }, :stocks]).find(@current_town.id)
      @user_stores = @current_town.stores.select { |s| s.user_id == current_user.id }
    end
    @total_stock_count  = Stock.joins(:store).where(stores: { user_id: current_user.id }).count
    @listed_stock_count = Stock.joins(:store).where(stores: { user_id: current_user.id }, listed: true).count
  end
end
