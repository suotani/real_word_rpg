class Store::DashboardController < Store::ApplicationController
  def index
    @towns = current_user.towns.includes(:stores, :items)
  end
end
