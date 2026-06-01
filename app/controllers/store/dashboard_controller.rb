class Store::DashboardController < Store::ApplicationController
  def index
    @current_town = current_user.town
    if @current_town
      @current_town = Town.includes(stores: [:store_category, :stocks]).find(@current_town.id)
      @user_stores = @current_town.stores.select { |s| s.user_id == current_user.id }
    end
  end
end
