class CustomDeviseController < ApplicationController

  def user_sign_up

    if User.find_by(email: params['email']).present?
      render json: {message: 'email已被註冊'}, status: 409
      return
    end

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
      if user.blank?
        render json: {message: '無此用戶'}, status: 422
        return
      end

      unless user.valid_password?(params['password'])
        render json: {message: '密碼錯誤'}, status: 422
        return
      end

      sign_in(user)
      render json: { current_user: {id: current_user.id, email: current_user.email} }, status: 200
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

  # FB登入
  def user_facebook_login
    # 驗證 access_token
    unless valid_facebook_token(params['access_token'], params['user_profile']['id'])
      render json: { message: 'facebook登入失敗' }, status: 401
      return
    end

    user_profile = params['user_profile']
    begin
      user = User.from_facebook(user_profile)
      sign_in(user)
      render json: { current_user: {id: current_user.id, email: current_user.email} }, status: 200
    rescue => e
      Rails.logger.debug e
      render json: {message: e.message}, status: 500
    end
  end

  private

  def valid_facebook_token(token, uid)
    begin
      response = RestClient.get "https://graph.facebook.com/debug_token?input_token=#{token}&access_token=#{Settings.facebook.app_id}|#{Settings.facebook.app_secret}"
      data = JSON.parse(response.body)['data']
      return data['is_valid'] && data['app_id'] == Settings.facebook.app_id && data['user_id'] == uid
    rescue => e
      Rails.logger.debug e
      return false
    end
  end

end
