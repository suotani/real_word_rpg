FactoryBot.define do
  factory :sales_log do
    association :user
    target_date   { Date.current }
    sales_count   { 0 }
    sales_amount  { 0 }
    cost_amount   { 0 }
  end
end
