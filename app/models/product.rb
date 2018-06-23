class Product < ApplicationRecord

  has_one_attached :img

  # validates_presence_of :title, :description

end
