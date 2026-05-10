class Material < ApplicationRecord
  belongs_to :item
  belongs_to :recipe, class_name: 'Item', optional: true
end
