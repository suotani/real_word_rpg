class Store::BuisinessTimesController < Store::ApplicationController
  def index
    store_categories = StoreCategory.where.not(name: '卸市場')
                                     .includes(:buisiness_times)
                                     .order(:listing_fee)

    @store_categories_by_hour = Hash.new { |h, k| h[k] = [] }
    store_categories.each do |store_category|
      store_category.buisiness_times.map(&:sales_at).uniq.each do |hour|
        @store_categories_by_hour[hour] << store_category
      end
    end
  end
end
