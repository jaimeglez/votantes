Rails.application.routes.draw do
  devise_for :admins
  root 'dashboard#index'
  namespace :admin do
    resources :zones
    resources :sections
    resources :squares
    resources :voter_documents, except: [ :edit, :destroy, :update ]
    resources :messages, except: [ :edit, :destroy, :update ]
  end


end
