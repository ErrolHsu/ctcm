class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # 通用的vue props
  expose(:props) { { current_user: get_current_user, user_login: current_user.present? }.to_json }

  include CartsHelper

  private

  def error_log(action, msg)
    log = Logger.new("#{Rails.root}/log/error.log")
    log.info "[#{action}] #{msg}"
    # TODO
    # slack
  end

  def ecpay_log(action, msg)
    log = Logger.new("#{Rails.root}/log/ecpay.log")
    log.info "[#{action}] #{msg}"
    # TODO
    # slack
  end

  def get_current_user
    if current_user
      current_user.as_json(only: :email)
    else
      {}
    end
  end

  def current_user?
    redirect_to root_path unless user_signed_in?
    return
  end
end
