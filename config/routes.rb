Rails.application.routes.draw do

  devise_for :users
  devise_scope :user do
    get "/register", to: "devise/registrations#new", as: :register
    get "/signin", to: "devise/sessions#new", as: :signin
  end
  root to: "static_pages#home"
end
