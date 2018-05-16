module CartsHelper
  def current_cart
    if current_user
      @cart ||= Cart.find_cart(current_user.id)
    else
      @cart ||= Cart.from_hash(session[current_user.id])
      # session的購物車要在補上
    end
  end
end
