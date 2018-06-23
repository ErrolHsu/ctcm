class OrderItem < ApplicationRecord
  belongs_to :order
  has_one_attached :img, dependent: false
end
