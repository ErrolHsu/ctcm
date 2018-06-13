# reference: https://oawan.me/2016/rails-devise-using-facebook-signup-login/
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      @user = User.from_omniauth(request.env["omniauth.auth"])  # 這邊會呼叫我們在 user 中定義的創建行為
      
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      else
        
        if @user.email.nil?
          # 如果 User 沒有提供 email 刪除 User 的 app 讓 User 重新授權
          @user.delete_access_token(request.env["omniauth.auth"])
          redirect_to new_user_registration_url, alert: "需要您同意 Email 授權唷！"
        else
          session["devise.facebook_data"] = request.env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    end

    def failure
      redirect_to new_user_session_path, alert: "無法獲得驗證！"
    end
  end