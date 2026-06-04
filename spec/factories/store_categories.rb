FactoryBot.define do
  factory :store_category do
    sequence(:name) { |n| "カテゴリ#{n}" }
  end
end
