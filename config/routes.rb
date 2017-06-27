Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: "sessions",
    registrations: "registrations",
    omniauth_callbacks: "omniauth_callbacks"
  }

  resources :users, except: [:new, :create]
  devise_scope :user do
    get "/register", to: "registrations#new", as: :register
    get "/signin", to: "sessions#new", as: :signin
    match "/users/:id/finish_signup", to: "users#finish_signup",
      via: [:get, :patch], as: :finish_signup
    match "users/:id", to: "users#destroy", via: :delete, as: :admin_destroy_user
  end

  root to: "static_pages#home"
end
