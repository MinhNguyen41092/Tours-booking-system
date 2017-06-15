Rails.application.routes.draw do

  devise_for :users, controllers: {
    sessions: "sessions"
  }
  devise_scope :user do
    get "/register", to: "devise/registrations#new", as: :register
    get "/signin", to: "sessions#new", as: :signin
  end
  root to: "static_pages#home"
end
