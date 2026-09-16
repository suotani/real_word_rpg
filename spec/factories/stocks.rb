FactoryBot.define do
  factory :stock do
    sequence(:name) { |n| "商品#{n}" }
    cost       { 100 }
    base_price { 150 }
    price      { 150 }
    listed     { false }
    association :store
    association :user
    association :item_sub_category

    trait :listed do
      listed     { true }
      base_price { 200 }
      price      { 200 }
    end
  end
end
