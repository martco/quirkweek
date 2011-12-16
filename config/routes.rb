Quirkweek::Application.routes.draw do

  #root :to => 'missions#index'
  root :to => "users#new"

  resources :missions
  resources :comments
  
  get "login"          => "sessions#login"
  get "signout"        => "sessions#signout"
  post "attempt_login" => "sessions#attempt_login"
    
  get "signup" => "users#new"
  post "signup" => "users#create"
  
  match "/auth/:provider/callback" => "sessions#create"

end
