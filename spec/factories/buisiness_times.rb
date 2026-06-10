FactoryBot.define do
  factory :buisiness_time do
    sales_at { 12 }
    association :store_category
  end
end
