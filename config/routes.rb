Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root 'home#index'
  get 'temp' => 'home#index'
  # 拿到定期訂單用 product
  get 'find_period_order_products' => 'home#find_period_order_products'

  get 'home/initialize_data' => 'home#initialize_data'
  post 'home/trial_request' => 'home#trial_request'

  # 索取試用頁
  get 'trial' => 'home#trial'
  get 'free_sample' => 'home#landing_page'

  # checkout頁
  get 'checkout' => 'carts#checkout'
  post 'checkout/jwt_encode' => 'carts#jwt_encode'
  post 'checkout/jwt_decode' => 'carts#jwt_decode'

  # 靜態頁面
  get 'people' => 'static#people'
  get 'farm_info' => 'static#farm_info' # 莊園農場
  get 'history' => 'static#history' # 創辦歷程
  get 'goals' => 'static#goals' # 展望與目標
  get 'FAQ' => 'static#faq' # FAQ

  get 'privacy_policy' => 'static#privacy_policy' # 隱私保護政策
  get 'account_policy' => 'static#account_policy' # 隱私保護政策

  # user註冊登入
  devise_scope :user do
    post 'user_sign_up' => 'custom_devise#user_sign_up'
    post 'user_login' => 'custom_devise#user_login'
    get 'user_sign_out' => 'custom_devise#user_sign_out'
    # facebook登入
    post 'user_facebook_login' => 'custom_devise#user_facebook_login'
  end

  namespace :account do
    get 'index' => 'users#index'
    resources :orders, only: [:show] do
      member do
        get 'cancel_subscribe' => 'orders#cancel_subscribe'
      end
    end
  end

  resources :products

  resources :orders do
    member do
      post 'pay' => 'orders#pay'
    end
    collection do
      post 'create_period_order' => 'orders#create_period_order'
      post 'ecpay_generate' => 'orders#ecpay_generate'
      post 'ecpay_return' => 'orders#ecpay_return'
    end
  end

  resource :cart, only: [:show, :destroy] do
    collection do
      post :add, path:'add/:id'
      get 'checkout' => 'carts#checkout'
    end
  end

  # ecpay
  # 定期訂單 notify
  post 'ecpay/period_order_notify' => 'ecpay#period_order_notify'

  # 後台

  namespace :admin do
    root 'core#index'
    get 'index' => 'core#index'
    resources :products
    resources :articles
    resources :orders
    resources :trials, only: [:index, :show] do
      member do
        post :shipping
        post :request_reject
        post :reset
      end
      collection do
        post :filter
      end
    end
  end

end
