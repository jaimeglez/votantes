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

  get '/voter_passwords/edit', to: 'voter_passwords#edit'
  put '/voter_passwords/update', to: 'voter_passwords#update'
  get '/voter_passwords/success', to: 'voter_passwords#success'

  # token auth routes available at /api/v1/auth
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :voters
      resources :zones, only: [:index]
      resources :sections, only: [:index]
      resources :squares, only: [:index]
      mount_devise_token_auth_for 'Voter', at: 'auth', skip: [:omniauth_callbacks], controllers: {
        registrations:  'overrides/registrations',
        sessions:  'overrides/sessions'
      }
    end

  end

  # api_version(module: "api/v1", header: {name: "API-VERSION-1", value: "v1"}, defaults: {format: :json}, path: {value: "api/v1"}, default: false) do
  # end

end
