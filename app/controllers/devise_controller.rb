class DeviseController < ApplicationController


  def user_sign_up
    begin
      user = User.create!(email: params['email'], password: params['password'])
      sign_in(user)
      render json: { current_user: {id: current_user.id, email: current_user.email} }, status: 200
    rescue => e
      Rails.logger.debug e
      render json: {message: e.message}, status: 500
    end
  end

  def user_login
    begin
      user = User.find_for_authentication(:email => params['email']);
      if user && user.valid_password?(params['password']);
        sign_in(user)
        render json: { current_user: {id: current_user.id, email: current_user.email} }, status: 200
      else
        render json: {message: '無此用戶或密碼錯誤'}, status: 500
      end
    rescue => e
      Rails.logger.debug e
      render json: {message: e.message}, status: 500
    end
  end

  def user_sign_out
    if current_user
      sign_out(current_user)
      render json: {}, status: 200
    else
      render json: { message: 'fail...' }, status: 500
    end
  end

end
