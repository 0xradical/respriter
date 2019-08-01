Rails.application.routes.draw do

  mount Vueonrails::Engine, at: 'vue'
  root to: 'home#index', subdomain: ENV.fetch('ROOT_SUBDOMAIN') { '' }

  get '/privacy-policy',        to: 'static_pages#index', page: 'privacy_policy'
  get '/terms-and-conditions',  to: 'static_pages#index', page: 'terms_and_conditions'

  get '/search', to: 'courses#index',  as: :courses
  get '/:provider/courses/:course', {
    constraints: {
      provider: Provider.slugged.pluck(:slug).join('|')
    },
    to: 'courses#show',
    as: :course
  }

  resources :posts, path: 'blog'

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

  get '/forward/:id', to: 'gateway#index', as: :gateway

  get '/:tag',
  to: 'course_bundles#index',
  constraints: {
    tag: RootTag.all.map { |t| t.slugify }.join('|')
  },
  as: :course_bundles

  concern :imageable do
    resources :images, shallow: true
  end

  namespace :api do
    namespace :admin do

      namespace :v1 do
        resource  :profile, only: :update
        resources :courses
        resources :earnings
        resources :enrollments
        resources :providers
        resources :rake_tasks do
          collection do
            put 'run', action: :run
          end
        end
        resources :user_accounts
      end

      authenticated :admin_account do
        namespace :v2 do

          resource :profile do
            resource :avatar, only: :create
          end

          resources :images
          resources :posts, concerns: [:imageable] do
            member do
              put 'publish',    action: :publish
              put 'disable',    action: :disable
            end
          end

        end
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

  # Redirects
  get 'arduino-for-beginners'                                       => redirect('/arduino')
  get 'the-complete-arduino-courses-catalog'                        => redirect('/arduino')
  get 'autocad-for-beginners'                                       => redirect('/autocad')
  get 'c-for-beginners'                                             => redirect('/c-programming')
  get 'cplusplus-for-beginners'                                     => redirect('/cplusplus-programming')
  get 'computer_science'                                            => redirect('/computer-science')
  get 'excel-for-beginners'                                         => redirect('/excel')
  get 'horas-complementares-administracao'                          => redirect('/')
  get 'horas-complementares-analise-desenvolvimento-sistemas'       => redirect('/')
  get 'horas-complementares-ciencias-contabeis'                     => redirect('/')
  get 'horas-complementares-direito'                                => redirect('/')
  get 'horas-complementares-educacao-fisica'                        => redirect('/')
  get 'horas-complementares-enfermagem'                             => redirect('/')
  get 'horas-complementares-engenharia-civil'                       => redirect('/')
  get 'horas-complementares-engenharia-producao'                    => redirect('/')
  get 'horas-complementares-letras-en'                              => redirect('/')
  get 'horas-complementares-pedagogia'                              => redirect('/')
  get 'horas-complementares-recursos-humanos'                       => redirect('/')
  get 'html-and-css-for-beginners'                                  => redirect('/html')
  get 'java-for-beginners'                                          => redirect('/java-programming')
  get 'javascript-for-beginners'                                    => redirect('/javascript-programming')
  get 'learn-react-a-journey-from-beginner-to-advanced'             => redirect('/reactjs')
  get 'learn-angular'                                               => redirect('/angularjs')
  get 'learn-bootstrap'                                             => redirect('/bootstrap')
  get 'learn-csharp'                                                => redirect('/csharp-programming')
  get 'learn-data-structures-and-algorithms'                        => redirect('/data-structures-and-algorithms')
  get 'learn-git'                                                   => redirect('/git')
  get 'learn-node-js'                                               => redirect('/nodejs')
  get 'python-for-beginners'                                        => redirect('/python-programming')
  get 'the-complete-python-courses-catalog'                         => redirect('/python-programming')
  get 'seo-for-beginners'                                           => redirect('/seo')
  get 'the-complete-computer-networking-courses-catalog'            => redirect('/computer-networks')
  get 'the-complete-php-courses-catalog'                            => redirect('/php-programming')
  get 'the-complete-postgresql-courses-catalog'                     => redirect('/postgresql')
  get 'the-complete-r-programming-language-courses-catalog'         => redirect('/r-programming')
  get 'the-complete-raspberry-pi-courses-catalog'                   => redirect('/raspberry-pi')
  get 'the-complete-vuejs-courses-catalog'                          => redirect('/vuejs')
  get 'the-complete-webpack-courses-catalog'                        => redirect('/webpack')
  get 'the-complete-matlab-courses-catalog'                         => redirect('/matlab')

  get '/:tag', to: 'course_bundles#show', as: :course_bundle, constraints: { tag: /[a-zA-Z0-9-]*/ }

end
