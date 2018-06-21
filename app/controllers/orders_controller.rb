class OrdersController < ApplicationController

  expose :period_orders, -> { current_user.period_orders }
  expose :order

  def index

  end

  def create
    # 測試
    product = Product.find_by(id: params[:product_id])
    order = current_user.orders.create(
      total: product.price * 12,
      regular: true,
      period_type: 'month',
      period_amount: product.price,
      frequency: 1,
      exec_times: 12,
    )

    order.items.create(
      product_name: product.title,
      price: product.price,
      quantity: 1
    )

    order.create_shipping_address(
      address: '台北市松山區八德路三段巷15號3樓',
    )

    redirect_to order_path(order)

  end

  def show

  end

  def pay
    order = Order.find_by(id: params[:id])
    date = Date.today

    12.times do |i|
      order.period_orders.create(
        user_id: current_user.id,
        no: i,
        amount: 100,
        expected_date: date + (i - 1).month,
        paid: false,
      )
    end

    redirect_to root_path
  end

end
