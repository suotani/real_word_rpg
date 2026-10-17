FactoryBot.define do
  factory :baito do
    association :store
    recipe { create(:recipe, store: store) }
    quantity { 1 }
    pricing_mode { 'fixed' }
    fixed_price { 300 }

    trait :multiplier do
      pricing_mode { 'multiplier' }
      fixed_price { nil }
      price_multiplier { 1.5 }
    end
  end
end
