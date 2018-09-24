class Account::UsersController < ApplicationController
  before_action :current_user?

  expose(:orders) { current_user.orders }

  def index

  end

  private

  def current_user?
    redirect_to root_path unless user_signed_in?
    return
  end

end
