class OrdersController < ApplicationController

  expose(:orders) { current_user.orders }
  expose(:period_orders) { current_user.period_orders }
  expose(:order)

  def index

  end

  def create
    # 測試
    product = Product.find_by(id: params[:product_id])
    order = current_user.orders.create(
      total: 100 * 12, # TODO
      regular: true,
      period_type: 'month',
      period_amount: 100, # TODO
      frequency: 1,
      exec_times: 12,
    )

    order_item = order.items.create(
      product_name: product.title,
      price: 100,  #  TODO
      quantity: 1
    )

    # add img
    if product.img.attached?
      product_img = product.img.blob
      order_item.img.attach(product_img)
    end

    order.create_shipping_address(
      address: '台北市松山區八德路三段巷15號3樓',
    )

    redirect_to order_path(order)

  end

  def create_period_order
    unless current_user.present?
      render json: { message: 'please login!' }
      return
    end
    # TODO
    # valid customer_set
    customer_set = params['customer_set']
    product = Product.find_by(id: customer_set[:product_id])
    variant = ProductVariant.find_by(id: customer_set['variant_id'])
    frequency = get_frequency(customer_set['period'])
    order = current_user.orders.create!(
      total: variant.price * customer_set['time'],
      regular: true,
      period_type: 'day',
      period_amount: variant.price,
      frequency: frequency,
      exec_times: customer_set['time'],
      status: 'open',
      payment_status: 'pending',
      shipping_status: 'unshipping',
    )

    order.items.create!(
      product_name: "#{product.title} #{variant.weight}",
      price: variant.price,
      quantity: 1,
      product_id: product.id,
      variant_id: variant.id,
    )

    order.create_shipping_address!(address: customer_set['address'])

    render json: {message: "#{params['data']}建立訂單成功"}
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

  private

  def get_frequency(period)
    case period
    when '每週'
      7
    when '隔週'
      14
    when '三週'
      21
    when '每月'
      30
    end
  end

end
