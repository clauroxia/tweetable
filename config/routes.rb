Rails.application.routes.draw do
  root to: "tweets#index"
  devise_for :users, controllers: { omniauth_callbacks: :callbacks }
  resources :tweets do
    resources :tweets
    post "like", on: :member
    delete "unlike", on: :member
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
