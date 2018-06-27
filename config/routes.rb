Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root 'home#index'
  get 'home/initialize_data' => 'home#initialize_data'

  resource :cart, only:[:show, :destroy] do
    collection do
      post :add, path:'add/:id'
      get 'checkout' => 'carts#checkout'
    end
  end

  resources :products

  resources :orders do
    member do
      post 'pay' => 'orders#pay'
    end
    collection do
      post 'create_period_order' => 'orders#create_period_order'
    end
  end

  namespace :admin do
    root 'core#index'
    get 'index' => 'core#index'
    resources :products
    resources :articles
    resources :orders
  end

end
