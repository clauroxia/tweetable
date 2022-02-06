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
    post "/test/tweets", to: "tweets#testcreate", as: "test_create"
    patch "/test/tweets/:tweet_id", to: "tweets#testupdate", as: "test_update"
    delete "/test/tweets", to: "tweets#testdestroy", as: "test_destroy"
  end
  get "/profiles/:user_id", to: "profiles#index", as: "profiles"
end
