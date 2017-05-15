Rails.application.routes.draw do
  get '/swagger' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.json')
  devise_for :admins

  devise_scope :admin do
    authenticated :admin do
      root 'admin/dashboards#show', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  root to: 'devise/sessions#new'

  namespace :admin do
    resource :dashboard, only: :show
    get '/dashboard/chart/:type/(:parent)', to: 'dashboards#chart'
    resources :zones, except: [ :destroy, :show ]
    get '/zones/export/:id', to: 'zones#export', as: :zone_export
    resources :sections, except: [ :destroy, :show ]
    get '/sections/export/:id', to: 'sections#export', as: :section_export
    resources :squares, except: [ :destroy ]
    get '/squares/export/:id', to: 'squares#export', as: :square_export
    resources :voters
    resources :promoters, except: [:edit, :update]
    resources :sympathizers, except: [:show, :new, :create]
    resources :voter_documents, except: [ :edit, :destroy, :update ]
    resources :messages, except: [ :edit, :destroy, :update ]
  end

  get '/voter_passwords/edit', to: 'voter_passwords#edit'
  put '/voter_passwords/update', to: 'voter_passwords#update'
  get '/voter_passwords/success', to: 'voter_passwords#success'
  get '/voter_passwords/not_found', to: 'voter_passwords#not_found'

  # token auth routes available at /api/v1/auth
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :voters
      resources :zones, only: [:index]
      resources :sections, only: [:index]
      resources :squares, only: [:index]
      mount_devise_token_auth_for 'Voter', at: 'auth', skip: [:omniauth_callbacks], controllers: {
        registrations:  'overrides/registrations',
        sessions:  'overrides/sessions',
        passwords: 'overrides/passwords'
      }
    end

  end
end
