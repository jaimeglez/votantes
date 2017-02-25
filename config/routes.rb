Rails.application.routes.draw do
  get '/swagger' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')
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
    scope :v1 do
      # mount_devise_token_auth_for 'Voter', at: 'auth', skip: [:omniauth_callbacks], controllers: {
      #   registrations:  'api/v1/devise_token_auth/registrations',
      #   sessions:  'api/v1/devise_token_auth/sessions'
      # }

      mount_devise_token_auth_for 'User', at: 'auth2', skip: [:confirmation_callbacks, :omniauth_callbacks], controllers: {
        registrations:  'api/v1/devise_token_auth/registrations',
        sessions:  'api/v1/devise_token_auth/sessions'
      }
    end

  end

  api_version(module: "api/v1", header: {name: "API-VERSION-1", value: "v1"}, defaults: {format: :json}, path: {value: "api/v1"}, default: false) do
    resources :voters
    resources :zones, only: [:index]
    resources :sections, only: [:index]
    resources :squares, only: [:index]
  end

end
