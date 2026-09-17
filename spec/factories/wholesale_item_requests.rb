FactoryBot.define do
  factory :wholesale_item_request do
    sequence(:name) { |n| "リクエスト商品#{n}" }
    base_price { 100 }
    association :user
    association :item_category
  end
end
