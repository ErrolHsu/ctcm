class Account::OrdersController < ApplicationController
  before_action :current_user?

  expose(:order) { current_user.orders.find_by(order_no: params[:id]) }
  expose(:current_period_order) { order.period_orders.where(status: [:open, :pending]).last }
  expose(:next_period_order) { order.period_orders.where(status: [:future]).last }

  def show
  end
end
