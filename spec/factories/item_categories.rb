FactoryBot.define do
  factory :item_category do
    sequence(:name) { |n| "商品カテゴリ#{n}" }
  end
end
