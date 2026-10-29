FactoryBot.define do
  factory :fx_market_regime do
    trend { 'up' }
    computed_at { Time.current }
  end
end
