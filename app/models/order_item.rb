class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :variant
  has_one_attached :img, dependent: false
end
