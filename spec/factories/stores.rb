FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "テスト店#{n}" }
    theme_color     { '#ff0000' }
    theme_sub_color { '#0000ff' }
    association :user
    association :town
    association :store_category
  end
end
