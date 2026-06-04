FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:name)  { |n| "ユーザー#{n}" }
    password { 'password' }
    balance  { 0 }
  end
end
