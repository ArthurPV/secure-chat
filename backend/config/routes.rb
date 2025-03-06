Rails.application.routes.draw do
  scope module: :auth do
    devise_for :users, path: "auth", skip: :all
  end

  namespace :auth do
    devise_scope :user do
      post "sign_in", to: "authorization#create"
      delete "sign_out", to: "authorization#destroy"
    end
  end

  root "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
