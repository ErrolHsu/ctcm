class CartsController < ApplicationController

  expose(:product) { Product.find_by(id: params[:product_id]) }

  def add
    current_cart.add_item(params[:id])
    # session[current_user.id] = current_cart.serialize
    redirect_to admin_products_path, notice: '已加入購物車'
  end

  def destroy
    # session[current_user.id] = nil
    current_cart.cart_items.delete_all
    redirect_to admin_products_path, notice: "購物車已清空"
  end

  def checkout
  end
end
