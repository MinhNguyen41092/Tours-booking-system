Rails.application.routes.draw do

  post '/rate' => 'rater#create', :as => 'rate'
  devise_for :users, controllers: {
    sessions: "sessions",
    registrations: "registrations",
    omniauth_callbacks: "omniauth_callbacks"
  }

  resources :users, except: [:new, :create] do
    post "like",   to: "socializations#like"
    post "unlike", to: "socializations#unlike"
  end

  devise_scope :user do
    get "/register", to: "registrations#new", as: :register
    get "/signin", to: "sessions#new", as: :signin
  end
  match "/users/:id/finish_signup", to: "users#finish_signup",
    via: [:get, :patch], as: :finish_signup
  match "users/:id", to: "users#destroy", via: :delete, as: :admin_destroy_user

  root to: "static_pages#home"
  resources :tours
  resources :line_items
  resources :carts, only: [:show, :destroy]
  resources :orders do
    member do
      get "success"
      get "error"
      patch "payment"
    end
  end

  resources :reviews do
    resources :comments
    post "like",   to: "socializations#like"
    post "unlike", to: "socializations#unlike"
  end

  resources :comments do
    resources :comments
  end

  resources :categories
  resources :financial_reports
end
