class Account::OrdersController < ApplicationController
  before_action :current_user?

  expose(:order) { current_user.orders .find_by(order_no: params[:id]) }

  def show
  end
end
