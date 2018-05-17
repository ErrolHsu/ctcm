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

  def find_user_cart
    cart = Cart.find_by(user_id: current_user.id)
    if cart.blank?
      cart = Cart.find_by(id: session[:cart_id])
      cart.update_attributes(user_id: current_user.id)
    end
    cart
  end

end
