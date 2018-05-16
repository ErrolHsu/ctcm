class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items

  def add_item(product_id)
    found_item = self.cart_items.find { |item| item.product_id == product_id }

    if found_item
      found_item.increment
    else
      self.cart_items.create(product_id: product_id, quantity: 1)
    end
  end

  def self.find_cart(user_id)
    cart = Cart.find_by(user_id: user_id)
    if cart
      cart
    else
      Cart.create(user_id: user_id)
    end
  end

end
