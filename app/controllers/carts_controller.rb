class CartsController < ApplicationController
  def add
    current_cart.add_item(params[:id])
    # session[current_user.id] = current_cart.serialize
    redirect_to admin_products_path, notice: '已加入購物車'
  end

  def destroy
    # session[current_user.id] = nil
    print current_cart
    redirect_to admin_products_path, notice: "購物車已清空"
  end
end
