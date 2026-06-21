FactoryBot.define do
  factory :town do
    sequence(:name) { |n| "テスト街#{n}" }
    password { 'pass1234' }

    transient do
      owner { create(:user) }
    end

    after(:build) do |town, evaluator|
      town.user_id ||= evaluator.owner.id
      town.skip_wholesale_market_setup = true
    end
  end
end
