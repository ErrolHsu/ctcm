FactoryBot.define do
  factory :order do
    user nil
    total 1
    type ""
    status "MyString"
    payment_status "MyString"
    shipping_status "MyString"
    period_amount 1
    period_type "MyString"
    frequency 1
    exec_times 1
  end
end
