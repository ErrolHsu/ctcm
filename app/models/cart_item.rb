class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product


  def price
     product.price * quantity
  end

  def increment(n = 1)
    self.update(quantity: self.quantity += n)
  end

end