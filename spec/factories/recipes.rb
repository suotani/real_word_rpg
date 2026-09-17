FactoryBot.define do
  factory :recipe do
    sequence(:name) { |n| "レシピ#{n}" }
    association :store
    association :item_category
  end
end
