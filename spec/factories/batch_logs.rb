FactoryBot.define do
  factory :batch_log do
    target_date     { Date.current }
    hour            { 12 }
    purchased_count { 0 }
    total_amount    { 0 }
  end
end
