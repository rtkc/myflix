Myflix::Application.routes.draw do
  root to: 'pages#front'
  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  get '/sign_out', to: 'sessions#destroy'
  post '/update_queue', to: 'queue_items#update_queue'
  get '/people', to: 'relationships#index'
  get '/forgot_password', to: 'forgot_passwords#new'
  get '/forgot_password_confirmation', to: 'forgot_passwords#confirm'
  get '/expired_token', to: 'pages#expired_token'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search'
    end
    resources :reviews, only: [:create]
    resources :queue_items, only: [:create]
  end
  
  resources :categories, only: [:show]

  resources :users, only: [:new, :create, :index, :show, :update] do
    resources :relationships, only: [:create]
  end

  resources :queue_items, only: [:index, :destroy]

  resources :relationships, only: [:index, :destroy]

  resources :forgot_passwords, only: [:create]

  resources :password_resets, only: [:show, :create]
end