class Store::OtherStoresController < Store::ApplicationController
  def index
    town = current_user.town
    if town.nil?
      @towns_with_stores = []
      return
    end

    town_with_stores = town.stores.includes(:store_category, :user)
                           .reject { |s| s.user_id.nil? || s.user_id == current_user.id }
    @towns_with_stores = town_with_stores.any? ? [[town, town_with_stores]] : []
  end
end
