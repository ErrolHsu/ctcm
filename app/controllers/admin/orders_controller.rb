class Admin::OrdersController < AdminController

  expose(:orders) { Order.all }
  expose(:order)


  def index

  end

  def show

  end

end
