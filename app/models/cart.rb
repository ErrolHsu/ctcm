class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_item(product_id)
    found_item = self.cart_items.find_by(product_id: product_id)
    if found_item
      found_item.increment
    else
      self.cart_items.create(product_id: product_id, quantity: 1)
    end
  end


  def total_price
    self.cart_items.reduce(0) {|sum, item| sum + item.price}
  end

end
