class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :variant, class_name: 'ProductVariant'
  has_one_attached :img, dependent: false
end
