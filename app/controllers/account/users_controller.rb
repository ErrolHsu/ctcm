class Account::UsersController < ApplicationController
  before_action :current_user?, except: [:get_user]

  expose(:orders) { current_user.orders }
  expose(:subscribe_orders) { current_user.orders.includes(:items).subscribe_orders }

  def index

  end

  def get_user
    render json: { current_user: get_current_user, user_login: current_user.present? }
  end

  private


end
