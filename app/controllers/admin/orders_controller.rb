class Admin::OrdersController < AdminController

  expose(:orders) { Order.all }
  expose(:order)
  expose(:order_json) { order.to_json(except: [:id, :created_at, :updated_at], methods: [:status_name, :payment_name, :type]) }
  expose(:current_period_order) { order.period_orders.where(status: [:open, :pending]).last }
  expose(:next_period_order) { order.period_orders.where(status: [:future]).last }


  def index

  end

  def show

  end

end
