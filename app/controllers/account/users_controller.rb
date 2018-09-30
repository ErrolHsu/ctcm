class Account::UsersController < ApplicationController
  before_action :current_user?

  expose(:orders) { current_user.orders }
  expose(:subscribe_orders) { current_user.orders.includes(:items).subscribe_orders }

  def index

  end

  private


end
