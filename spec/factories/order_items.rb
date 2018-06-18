FactoryBot.define do
  factory :order_item do
    order nil
    product_name "MyString"
    price 1
    quantity 1
  end
end
