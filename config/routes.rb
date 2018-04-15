Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  # admin 登入後 root
  authenticated :admin do
    root 'admin/core#index', as: :authenticated_root
  end

  # 顧客登入後 root
  # authenticated :user do
  #   root ''
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'home/ajax' => 'home#ajax'

  namespace :admin do
    get 'index' => 'core#index'
  end
end
