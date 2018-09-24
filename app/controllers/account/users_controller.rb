class Account::UsersController < ApplicationController
  before_action :current_user?

  expose(:orders) { current_user.orders }

  def index

  end

  private


end
