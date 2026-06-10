FactoryBot.define do
  factory :item_sub_category do
    sequence(:name) { |n| "サブカテゴリ#{n}" }
    association :item_category
  end
end
