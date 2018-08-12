Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root 'home#index'
  get 'home/initialize_data' => 'home#initialize_data'
  post 'home/trial_request' => 'home#trial_request'

  # 索取試用頁
  get 'trial' => 'home#trial'
  get 'free_sample' => 'home#index'

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

  post 'ecpay/order_notify' => 'ecpay#order_notify'

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
