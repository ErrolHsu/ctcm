Rails.application.routes.draw do
  devise_for :admins
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root 'home#index'
  get 'home/ajax' => 'home#ajax'

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
  end

  namespace :admin do
    root 'core#index'
    get 'index' => 'core#index'
    resources :products
    resources :articles
    resources :orders
  end

end
