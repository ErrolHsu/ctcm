module CartsHelper
  def current_cart
    @cart ||= find_cart
  end

  def find_cart
    if current_user
      cart = find_user_cart
    else
      cart = Cart.find_by(id: session[:cart_id])
      cart = Cart.create unless cart.present?
    end

    session[:cart_id] = cart.id
    cart
  end

  # 有登入時的購物車
  def find_user_cart
    cart = current_user.cart
    if cart.blank?
      cart = Cart.find_by(id: session[:cart_id])
      cart.update_attributes(user_id: current_user.id)
    # 如果舊購物車存在，合併新舊購物車
    elsif (cart.id != session[:cart_id])
      new_cart = Cart.find_by(id: session[:cart_id])
      new_cart_products = new_cart.products.map(&:id)
      new_cart_products.each {|product| cart.add_item(product)}
      new_cart.destroy
      cart
    end
    cart
  end

end
