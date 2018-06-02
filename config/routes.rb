Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  resource :cart, only:[:show, :destroy] do
    collection do
      post :add, path:'add/:id'
    end
  end

  resources :products

  namespace :admin do
    root 'core#index'
    get 'index' => 'core#index'
    resources :products
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'home/ajax' => 'home#ajax'

end
