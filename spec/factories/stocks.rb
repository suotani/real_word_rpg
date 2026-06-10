FactoryBot.define do
  factory :stock do
    sequence(:name) { |n| "商品#{n}" }
    cost   { 100 }
    price  { 150 }
    listed { false }
    association :store
    association :user
    association :item_sub_category

    trait :listed do
      listed { true }
      price  { 200 }
    end
  end
end
