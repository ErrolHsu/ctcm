FactoryBot.define do
  factory :period_order do
    user nil
    order nil
    no 1
    amount 1
    expected_date "2018-06-10"
    status "MyString"
    paid false
    shipping_status "MyString"
  end
end
