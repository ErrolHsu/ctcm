class Admin::OrdersController < AdminController

  expose(:orders) { Order.all }
  expose(:order)
  expose(:order_json) { order.to_json(except: [:id, :created_at, :updated_at], methods: [:status_name, :payment_name, :type]) }
  expose(:current_period_order_json) { order.current_period_order_json }
  expose(:next_period_order) { order.period_orders.where(status: [:future]).last }


  def index
  end

  def show
  end

  # 當期定期訂單改為烘培中
  def period_order_preparing
    order = Order.find_by(order_no: params['id'])

    current_period_order = order.current_period_order

    unless current_period_order.try(:paid)
      render json: { message: '本期訂單尚未付款' }, status: 400
    end

    current_period_order.shipping_status = 'preparing'
    current_period_order.save

    # 通知消費者
    MailWorker::PeriodOrderPreparingJob.perform_later(order.id)

    render json: { message: '已通知顧客咖啡烘培中' , current_period_order_json: order.current_period_order_json }
  end

  # 當期定期訂單改為配送中
  def period_order_shipping
    order = Order.find_by(order_no: params['id'])
    tracking_no = params['trackingNo']

    current_period_order = order.current_period_order

    unless current_period_order.try(:paid)
      render json: { message: '本期訂單尚未付款' }, status: 400
    end

    current_period_order.shipping_status = 'shipping'
    current_period_order.tracking_no = tracking_no
    current_period_order.save

    # 最後一期
    if order.exec_times == current_period_order.no
      order.close!
    end

    # 通知消費者
    MailWorker::PeriodOrderShippingJob.perform_later(order.id)

    render json: { message: '已通知顧客咖啡配送中' , current_period_order_json: order.current_period_order_json }

  end

end
