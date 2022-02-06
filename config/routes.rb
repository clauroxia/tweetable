Rails.application.routes.draw do
  root to: "tweets#index"
  devise_for :users, controllers: { omniauth_callbacks: :callbacks }
  resources :tweets do
    resources :tweets
    post "like", on: :member
    delete "unlike", on: :member
  end
  namespace :api do
    resources :tweets, except: %i[new edit] do
      post "like", on: :member
      delete "unlike", on: :member
      get "/tweets", to: "tweets#replies", as: "show_replies"
    end
    resources :users, except: %i[new edit]
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
  end
  get "/profiles", to: "profiles#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
