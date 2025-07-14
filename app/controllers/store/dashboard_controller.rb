class Store::DashboardController < Store::ApplicationController
  before_action :authenticate_user!

  def index
    @towns = current_user.towns.includes(:stores, :items)
  end
end
