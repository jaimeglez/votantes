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

  # token auth routes available at /api/v1/auth
  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end


end
