Rails.application.routes.draw do
  devise_for :users,
  defaults: { format: :json },
  controllers: {
    sessions: "users/sessions"
  }


  # Custom routes for login/logout
  devise_scope :user do
    post "login", to: "users/sessions#create"
    delete "logout", to: "users/sessions#destroy"

    # Google OAuth
    get "/users/auth/google_oauth2", to: "users/omniauth_callbacks#google_oauth2"
    get "/users/auth/google_oauth2/callback", to: "users/omniauth_callbacks#google_oauth2"
  end

  namespace :advertisers do
    resources :ad_units, only: [ :create ]
  end

  namespace :api do
    post "auth/google", to: "auth#google"
  end

  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :users
  resources :advertisers, only: [ :create ]
  resources :publishers
  resources :ad_units
  resources :publisher_sites
  resources :ad_implementations
  resources :ad_performances

  resources :advertisers do
    resources :ad_units
  end

  get "/google_ads", to: "google_ads#index"

  # config/routes.rb
end
