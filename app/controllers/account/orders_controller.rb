class Account::OrdersController < ApplicationController
  before_action :current_user?

  expose(:order) { current_user.orders.find_by(order_no: params[:id]) }
  expose(:order_json) { order.to_json(only: [:id, :status, :order_no, :payment_status]) }
  expose(:current_period_order) { order.period_orders.where(status: [:open, :pending]).last }
  expose(:next_period_order) { order.period_orders.where(status: [:future]).last }

  def show
  end

  # 取消訂閱
  def cancel_subscribe
    order = current_user.orders.find_by(id: params['id'])
    # TODO 刪除定期訂單
    order.status = 'subscribe_cancel'
    order.save


    render json: { message: '已取消訂閱' , order_json: order_json }
  end
end
