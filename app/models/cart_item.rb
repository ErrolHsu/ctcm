class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  belongs_to :product_variant

  def price
     100 * quantity # TODO
  end

  def increment(n = 1)
    self.update(quantity: self.quantity += n)
  end

end
