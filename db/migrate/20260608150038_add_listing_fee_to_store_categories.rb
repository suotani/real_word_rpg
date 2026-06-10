class AddListingFeeToStoreCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :store_categories, :listing_fee, :integer, null: false, default: 200_000
  end
end
