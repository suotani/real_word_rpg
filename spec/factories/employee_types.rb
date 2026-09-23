FactoryBot.define do
  factory :employee_type do
    sequence(:name) { |n| "従業員種別#{n}" }
    hire_cost { 1000 }
    attractiveness_bonus { 0.0 }
    purchase_discount_rate { 0.0 }
    extra_customer_count { 0 }
    bonus_customer_balance_multiplier { 1.0 }
    virtual_sale_bonus_rate { 0.0 }
  end
end
