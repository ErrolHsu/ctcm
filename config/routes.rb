Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  # admin 登入後 root
  authenticated :admin do
    root 'admin/core#index', as: :authenticated_root
  end

  namespace :admin do
    root 'core#index'
    get 'index' => 'core#index'
    resources :products
  end
  # 顧客登入後 root
  # authenticated :user do
  #   root ''
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'home/ajax' => 'home#ajax'

end
