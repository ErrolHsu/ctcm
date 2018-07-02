class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

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
end
