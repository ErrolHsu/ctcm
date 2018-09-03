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

  # FB登入
  def user_facebook_login
    # 驗證 access_token
    unless valid_facebook_token(params['access_token'])
      render json: { message: 'facebook登入失敗' }, status: 500
      return
    end

    user_profile = params['user_profile']
    user = User.from_facebook(user_profile)
    sign_in(user)
    render json: { current_user: {id: current_user.id, email: current_user.email} }, status: 200
  end

  private

  def valid_facebook_token(token)
    begin
      response = RestClient.get "https://graph.facebook.com/debug_token?input_token=#{token}&access_token=#{Settings.facebook.app_id}|#{Settings.facebook.app_secret}"
      data = JSON.parse(response.body)['data']
      return data['is_valid'] && data['app_id'] == Settings.facebook.app_id
    rescue => e
      Rails.logger.debug e
      return false
    end
  end

end
