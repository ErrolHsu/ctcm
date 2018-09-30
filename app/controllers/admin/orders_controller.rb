class Admin::OrdersController < AdminController

  expose(:orders) { Order.all }
  expose(:order)
  expose(:current_period_order) { order.period_orders.where(status: [:open, :pending]).last }
  expose(:next_period_order) { order.period_orders.where(status: [:future]).last }


  def index

  end

  def show

  end

end
