class ItemCategoryStoreCategory < ApplicationRecord
  belongs_to :item_category
  belongs_to :store_category
end
