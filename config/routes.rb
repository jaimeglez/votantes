Rails.application.routes.draw do
  root 'dashboard#index'
  resources :zones
  resources :sections
  resources :squares

  resources :voters

end
