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
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      mount_devise_token_auth_for 'Voter', at: 'auth'

      resources :voters
    end

  end

  api_version(module: "api/v1", header: {name: "API-VERSION-1", value: "v1"}, defaults: {format: :json}, path: {value: "api/v1"}, default: false) do
  end

end
