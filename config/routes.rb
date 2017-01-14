Rails.application.routes.draw do
  devise_for :admins
  root 'dashboard#index'
  namespace :admin do
    resources :zones
    resources :sections
    resources :squares
  end

end
