class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :ecpay_return

  expose(:orders) { current_user.orders }
  expose(:period_orders) { current_user.period_orders }
  expose :order, scope: ->{ orders }
  expose(:ecpay_order) { get_ecpay_order(order) }

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
    frequency = customer_set['period'].to_i
    exec_times = customer_set['limit'].to_i / frequency

    order = current_user.orders.create!(
      order_no: generate_order_no,
      total: variant.price * exec_times,
      regular: true,
      period_type: 'D',
      period_amount: variant.price,
      frequency: frequency,
      exec_times: exec_times,
      status: 'open',
      payment_status: 'pending',
      shipping_status: 'unshipping',
      duration: customer_set['limit'].to_i,
    )

    order.items.create!(
      product_name: "#{product.title} #{variant.weight}",
      price: variant.price,
      quantity: 1,
      product_id: product.id,
      variant_id: variant.id,
    )

    order.create_shipping_address!(address: customer_set['address'])

    render json: {message: "#{params['data']}建立訂單成功", order: order.to_json}
  end

  def show
  end

  # 更新merchant_trade_no，並產生綠界訂單data
  def ecpay_generate
    order = Order.find_by(id: params['order_id'].to_i)
    begin
      order.merchant_trade_no = order.order_no + SecureRandom.hex(1).upcase
      order.save!

      ecpay_info = get_ecpay_info(order)

      render json: { ecpay_info: ecpay_info }
    rescue => e
      render json: { 'message' => '發生錯誤，請稍候重試。' }, status: 500
      error_log 'ecpay_generate', e.message
    end
  end

  # ecpay 付款完成返回網址
  # def ecpay_return
  #
  # end

  def pay
    order = Order.find_by(id: params[:id])
    date = Date.today

    order.exec_times.times do |i|
      date += order.frequency.days
      order.period_orders.create(
        user_id: current_user.id,
        no: i,
        amount: order.period_amount,
        expected_date: date,
        paid: false,
        status: 'pending',
      )
    end

    redirect_to root_path
  end

  private

  def generate_order_no
    Time.now.to_s(:no) + SecureRandom.hex(1).upcase
  end

  def get_ecpay_info(order)
    ecpay_order = EcpayServices::PeriodOrder.new(order)
    ecpay_order.call
  end

end
