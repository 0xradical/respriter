Rails.application.routes.draw do

  root to: 'home#index'

  get '/privacy-policy',        to: 'static_pages#index', page: 'privacy_policy'
  get '/terms-and-conditions',  to: 'static_pages#index', page: 'terms_and_conditions'

  NavigationalTag.all.each do |tag|
    get "/#{tag.slugify}", to: 'courses#index', tag: tag.id, as: tag.id
  end

  get '/search', to: 'courses#index',  as: :courses 

  # Devise
  devise_for :admin_accounts, controllers: { 
    sessions: 'admin_accounts/sessions' 
  }, defaults: { format: :json }

  devise_for :user_accounts, controllers: {
    sessions: 'user_accounts/sessions',
    registrations: 'user_accounts/registrations',
    omniauth_callbacks: 'user_accounts/omniauth_callbacks' 
  }

  namespace :user_accounts do
    match '*dashboard', to: 'dashboard#index', via: [:get], as: :dashboard
  end

  resources :videos, only: :show

  get '/forward/:id',           to: 'gateway#index',  as: :gateway

  get '/:id', to: 'landing_pages#show', as: :landing_pages

  concern :import do
    collection do 
      post 'import'
    end
  end

  namespace :api do

    namespace :admin do
      namespace :v1 do
        resource :profile, only: :update
        resources :user_accounts
        resources :earnings
        resources :enrollments
        resources :courses, concerns: [:import]
        resources :providers
        resources :landing_pages
        resources :landing_page_templates, only: [:index, :show]
        resources :rake_tasks do
          collection do
            put 'run', action: :run
          end
        end
      end
    end

    namespace :bot do
      namespace :v1 do
        resources :courses
      end
    end

    namespace :user do
      namespace :v1 do
        resource :account
        resource :profile
        resources :interests,      only: [:index, :create, :update, :destroy]
        resources :tags,           only: :index
        resources :images,         only: :create
        resources :oauth_accounts, only: [:destroy]
        resources :passwords,      only: :create
      end
    end

  end

end
