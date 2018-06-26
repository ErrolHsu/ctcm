class Product < ApplicationRecord

  has_one_attached :img
  has_many :variants, class_name: 'ProductVariant', dependent: :destroy

end
