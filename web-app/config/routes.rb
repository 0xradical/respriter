# frozen_string_literal: true

Rails.application.routes.draw do
  # Devise
  devise_for :admin_accounts,
             controllers: { sessions: 'admin_accounts/sessions' },
             defaults:    { format: :json }

  devise_for :user_accounts,
             skip:        %i[registrations],
             controllers: {
               sessions:           'user_accounts/sessions',
               passwords:          'user_accounts/passwords',
               omniauth_callbacks: 'user_accounts/omniauth_callbacks'
             }

  as :user_account do
    get '/user_accounts/sign_up(.:format)' => 'user_accounts/registrations#new',
        as: :new_user_account_registration
    post '/user_accounts(.:format)' => 'user_accounts/registrations#create',
         as: :user_account_registration
  end

  get  '/profile'     => 'profiles#new'
  post '/profile'     => 'profiles#create'

  devise_scope :user_account do
    get '/developers/sign_in(.:format)' => 'developers/sessions#new',
        as: :new_developer_session_path
  end

  root to: 'home#index', subdomain: ENV.fetch('ROOT_SUBDOMAIN') { '' }

  get '/unsubscriptions/:id',       to: 'unsubscriptions#show'
  post '/unsubscriptions/:id',      to: 'unsubscriptions#update'

  get '/privacy-policy',        to: 'static_pages#index', page: 'privacy_policy'
  get '/terms-and-conditions',  to: 'static_pages#index', page: 'terms_and_conditions'
  get '/get-listed',            to: 'static_pages#index', page: 'get_listed'
  get '/contact-us',            to: 'contact_us#new'
  post '/contact-us',           to: 'contact_us#create'

  get '/search', to: 'courses#index', as: :courses

  controller 'providers' do
    get '/:provider' => :show,
      constraints: ProviderConstraint.new,
      as: :provider
  end

  controller 'institutions' do
    get '/google-academy' => :show
  end

  controller 'courses' do
    get '/:provider/courses/:course' => :show,
        constraints: ProviderConstraint.new,
        to:          'show',
        as:          :course
  end

  controller 'instructors' do
    get '(/:provider)/instructors' => :index,
      constraints: ProviderConstraint.new(allow_blank: true),
      as: :instructors
  end

  resources :posts, path: 'blog'

  resources :user_accounts, path: 'users', only: %i[index show]

  direct :user_dashboard do
    "#{ENV.fetch('USER_DASHBOARD_URL') { '//user.classpert.com' }}?locale=#{
      I18n.locale
    }"
  end

  direct :developers_dashboard do
    "#{
      ENV.fetch('DEVELOPERS_DASHBOARD_URL') { '//listing.classpert.com' }
    }?locale=#{I18n.locale}"
  end

  direct :listing_api_documentation do
    "#{
      ENV.fetch('LISTING_API_DOCUMENTATION_URL') { '//listing.classpert.com/docs' }
    }?locale=#{I18n.locale}"
  end

  resources :videos, only: :show

  resources :orphaned_profiles, path: 'profiles', only: [:show] do
    member do
      get   '/claim',                   action: :claim
      put   '/send_verification_link',  action: :send_verification_link
    end
  end

  namespace :claims do
    get '/codes/:claim_code/verify',  to: 'codes#verify',           as: :code
    get '/social/:id',                to: 'social_networks#update', as: :social_network
  end

  controller 'gateway' do
    get '/forward'     => :index, as: :gateway
    # old interface for compatibility purposes
    get '/forward/:id' => :index
  end

  get '/reviews/:id', to: 'course_reviews#show', as: :course_review
  post '/reviews/:id', to: 'course_reviews#update'

  get '/:tag',
      to:          'course_bundles#index',
      constraints: { tag: /#{RootTag.all.map(&:slugify).join('|')}/ },
      as:          :course_bundles

  concern :imageable do
    resources :images, shallow: true
  end

  namespace :developers do
    resources :preview_courses, only: :show
    resources :preview_course_videos, only: :show
    authenticated :user_account do
      get '/provider_crawler/:id/start', to: 'provider_crawlers#start'
      get '/provider_crawler/:id/stop',  to: 'provider_crawlers#stop'
    end
  end

  namespace :api do
    namespace :admin do
      namespace :v1 do
        resource :profile, only: :update
        resources :courses
        resources :earnings
        resources :enrollments
        resources :providers
        resources :rake_tasks do
          collection { put 'run', action: :run }
        end
        resources :user_accounts
      end

      authenticated :admin_account do
        namespace :v2 do
          resource :profile do
            resource :avatar, only: :create
          end

          resources :images
          resources :posts, concerns: %i[imageable] do
            member do
              put 'publish', action: :publish
              put 'disable', action: :disable
            end
          end
        end
      end
    end

    namespace :user do
      namespace :v1 do
        resource :account
        resource :profile
        resources :interests, only: %i[index create update destroy]
        resources :tags, only: :index
        resources :images, only: :create
        resources :oauth_accounts, only: %i[destroy]
        resources :passwords, only: :create
      end
    end
  end

  # Redirects
  get '/pt-br/cursos-para-horas-complementares-gratis-com-certificado' =>
                                                                          redirect(
                                                                            '/blog/cursos-para-horas-complementares-gratis-e-com-certificado'
                                                                          )
  get 'arduino-for-beginners' => redirect('/arduino')
  get 'the-complete-arduino-courses-catalog' => redirect('/arduino')
  get 'autocad-for-beginners' => redirect('/autocad')
  get 'c-for-beginners' => redirect('/c-programming')
  get 'cplusplus-for-beginners' => redirect('/cplusplus-programming')
  get 'computer_science' => redirect('/computer-science')
  get 'excel-for-beginners' => redirect('/excel')
  get 'horas-complementares-administracao' => redirect('/')
  get 'horas-complementares-analise-desenvolvimento-sistemas' => redirect('/')
  get 'horas-complementares-ciencias-contabeis' => redirect('/')
  get 'horas-complementares-direito' => redirect('/')
  get 'horas-complementares-educacao-fisica' => redirect('/')
  get 'horas-complementares-enfermagem' => redirect('/')
  get 'horas-complementares-engenharia-civil' => redirect('/')
  get 'horas-complementares-engenharia-producao' => redirect('/')
  get 'horas-complementares-letras-en' => redirect('/')
  get 'horas-complementares-pedagogia' => redirect('/')
  get 'horas-complementares-recursos-humanos' => redirect('/')
  get 'html-and-css-for-beginners' => redirect('/html')
  get 'java-for-beginners' => redirect('/java-programming')
  get 'javascript-for-beginners' => redirect('/javascript-programming')
  get 'learn-react-a-journey-from-beginner-to-advanced' => redirect('/reactjs')
  get 'learn-angular' => redirect('/angularjs')
  get 'learn-bootstrap' => redirect('/bootstrap')
  get 'learn-csharp' => redirect('/csharp-programming')
  get 'learn-data-structures-and-algorithms' =>
                                                redirect('/data-structures-and-algorithms')
  get 'learn-git' => redirect('/git')
  get 'learn-node-js' => redirect('/nodejs')
  get 'python-for-beginners' => redirect('/python-programming')
  get 'the-complete-python-courses-catalog' => redirect('/python-programming')
  get 'seo-for-beginners' => redirect('/seo')
  get 'the-complete-computer-networking-courses-catalog' =>
                                                            redirect('/computer-networks')
  get 'the-complete-php-courses-catalog' => redirect('/php-programming')
  get 'the-complete-postgresql-courses-catalog' => redirect('/postgresql')
  get 'the-complete-r-programming-language-courses-catalog' =>
                                                               redirect('/r-programming')
  get 'the-complete-raspberry-pi-courses-catalog' => redirect('/raspberry-pi')
  get 'the-complete-vuejs-courses-catalog' => redirect('/vuejs')
  get 'the-complete-webpack-courses-catalog' => redirect('/webpack')
  get 'the-complete-matlab-courses-catalog' => redirect('/matlab')

  get '/:tag',
      to:          'course_bundles#show',
      as:          :course_bundle,
      constraints: { tag: /[a-zA-Z0-9-]*/ }
end
