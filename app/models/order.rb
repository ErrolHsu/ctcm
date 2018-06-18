class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :period_orders
end
