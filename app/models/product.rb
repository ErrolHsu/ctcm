class Product < ApplicationRecord

  has_one_attached :img
  has_many :product_variants

end
