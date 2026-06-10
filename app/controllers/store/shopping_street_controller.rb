class Store::ShoppingStreetController < Store::ApplicationController
  def index
    town = current_user.town
    if town
      @town   = town
      @stores = town.stores
                    .where.not(user_id: nil)
                    .includes(:store_category, :user, :stocks)
                    .order(:name)
    else
      @town   = nil
      @stores = []
    end
  end
end
