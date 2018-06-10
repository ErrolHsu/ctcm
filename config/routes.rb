Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  root 'home#index'
  get 'home/ajax' => 'home#ajax'

  resource :cart, only:[:show, :destroy] do
    collection do
      post :add, path:'add/:id'
    end
  end

  resources :products

  resources :orders

  namespace :admin do
    root 'core#index'
    get 'index' => 'core#index'
    resources :products
    resources :articles
  end

end
