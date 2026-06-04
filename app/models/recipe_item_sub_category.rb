class RecipeItemSubCategory < ApplicationRecord
  belongs_to :recipe
  belongs_to :item_sub_category
end
