class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :ecpay_return

  # expose(:orders) { current_user.orders }
  expose(:period_orders) { current_user.period_orders }
  # expose :order, scope: ->{ orders }
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
      render json: { message: '請先登入' }, status: 400
      return
    end

    begin
      # TODO
      # valid period_order_total_data

      period_order_total_data = params['period_order_total_data']

      # token 裡面有當初選擇的product與variant資料等等資料
      token = period_order_total_data['token']
      decode_token = JwtHelper::Decode.call(token).payload
      product = decode_token['product']
      variant = decode_token['variant']

      # decode_token['duration']  拿到的為幾月，要轉成 天
      duration = decode_token['duration'] * 30

      # decode_token['frequency'] 拿到的為幾週，要轉成 天or月
      # decode_token['frequency'] == 4 表示為一個月一次
      if decode_token['frequency'] == 4
        frequency = 1 # 1 月/次
        exec_times = decode_token['duration'] / frequency # 預計執行次數
        period_type = 'M' # 週期是以月為單位
      else
        frequency = decode_token['frequency'] * 7 # n 天/次
        exec_times = duration / frequency # 預計執行次數
        period_type = 'D' # 週期是以天為單位
      end

      # shipping_info
      shipping_info = period_order_total_data['shipping_info']
      # 定期配送運費為零
      shipping_rate = 0

      ActiveRecord::Base.transaction do
        # 建立訂單
        order = current_user.orders.create!(
          order_no: generate_order_no,
          total: variant['price'] * exec_times,
          period: true,
          period_type: period_type,
          period_amount: variant['price'],
          frequency: frequency,
          exec_times: exec_times,
          status: 'open',
          payment_status: 'pending',
          shipping_status: 'period',
          duration: duration,
          shipping_rate: shipping_rate,
          payment: 'credit',
        )

        #建立 訂單 items
        order.items.create!(
          product_name: "#{product['title']} #{variant['weight']}",
          price: variant['price'],
          quantity: 1,
          product_id: product['id'],
          variant_id: variant['id'],
        )

        # 建立首張period_order
        order.period_orders.create!(
          user_id: current_user.id,
          no: 1,
          amount: variant['price'],
          status: 'open',
          paid: false,
          shipping_status: 'pending',
        )
        # 建立收件資訊
        order.create_shipping_address!(
          name: shipping_info['name'],
          address: shipping_info['address'],
          email: shipping_info['email'],
          phone: shipping_info['phone'],
        )

        Mailer::PeriodOrderCreateJob.perform_later(order.id)
        render json: {message: "建立訂單成功", order_no: order.order_no}
      end

    rescue => e
      render json: { 'message' => '建立訂單錯誤，請稍候重試。' }, status: 500
      Reporter.error(e, "建立訂單錯誤 file: #{__FILE__}")
    end
  end

  def show
  end

  # 更新merchant_trade_no，並產生綠界訂單data
  def ecpay_generate
    order = Order.find_by(order_no: params['order_no'])
    begin
      order.merchant_trade_no = order.order_no + SecureRandom.hex(1).upcase
      order.save!

      # ecpay_info = get_ecpay_info(order)
      ecpay_info = EcpayServices::PeriodOrder.call(order)
      render json: { ecpay_info: ecpay_info }
    rescue => e
      render json: { 'message' => '發生錯誤，請稍候重試。' }, status: 500
      Reporter.error(e, "ecpay_generate error file: #{__FILE__}")
      # error_log 'ecpay_generate', e.message
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
