class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include CartsHelper

  private

  def error_log(action, msg)
    File.open('log/error.log', 'a') do |f|
      f.write "[#{Time.now.to_s(:complete)}][#{action}] #{msg}\n"
    end
  end
end
