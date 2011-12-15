Quirkweek::Application.routes.draw do

  #root :to => 'missions#index'
  root :to => "users#new"

  resources :missions
  resources :comments
  
  get "login" => "sessions#login"
#  get "logout" => "sessions#logout"
  post "attempt_login" => "sessions#attempt_login"
  get "welcome" => "sessions#welcome"
    
  get "signup" => "users#new"
  post "signup" => "users#create"
  
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout"                 => "sessions#destroy", :as => :signout

end
