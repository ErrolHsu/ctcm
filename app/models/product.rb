class Product < ApplicationRecord
  validates_presence_of :title, :description, :price, :quantity
  validates_numericality_of :price, :quantity
end
