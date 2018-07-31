Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions      => "users/sessions",
  }
  root 'classes/lesson#index'

  get 'term', to: 'term#index'
  get 'term/privacy'
  get 'about', to: 'about#index'

  devise_scope :user do
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  resources :lesson, :module => :classes, :as => 'lesson' do
    collection do
      get :departments_select
      get :first_login
      get :search
      get :ml_api
    end
    resources :result, :except => [:show], :as => 'result'
    member do
      post "add", to: "favorites#create"
      post "none", to: "favorites#none"
      resources :favorites, only: [:destroy]
    end
  end
  resources :reviews, only: [:index], module: :classes
  resources :faculties, only: %i(index)
  resources :rankings, only: [:index], module: 'classes'
  resources :textbooks, only: %i(index show) do
    collection do
      get :search
      post :ship
      get :purchase
    end
  end
  resources :book_requests, only: %i(show)
  resources :conversations, only: %i(show create)
  resources :messages, only: %i(create)
  resources :notifies, only: %i(create)
  resources :chat_rooms, only: %i(index show new create) do
    member do
      resources :posts, only: %i(create)
    end
  end
  resources :class_rooms, only: [:index]
  resources :user_notifications do
    collection do
      get :update_readed_at
    end
  end
  get 'mypage', :to => 'classes/result#index', as: 'mypage'
  resources :feature, only: [:show], module: 'classes'
  resources :pdfs, only: [:index] do
    collection do
      get :result
    end
  end

  resources :questionnaires, only: [:index]

  post 'login/login'

  namespace :admin do
    root to: 'top#index'
    get 'top/index'
    resources :faculty
    resources :category do
      post :toggle_published
    end
    resources :chat_rooms do
      post :toggle_published
    end
    resources :department
    resources :result
    resources :user
    resources :feature
    resources :posts
    resources :book_requests
    resources :lesson do
      collection do
        get 'search'
      end
    end
    resources :textbooks do
      collection do
        get 'search'
      end
    end
    resources :bookstores
  end

  # 常に一番下に。
  # get '*path', to: 'application#render_404'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
