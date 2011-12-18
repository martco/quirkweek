Quirkweek::Application.routes.draw do

  root :to => 'missions#index'

  resources :missions
  resources :comments
  
  get "login"          => "sessions#login"
  get "logout"        => "sessions#signout"
  post "attempt_login" => "sessions#attempt_login"
    
  get "signup"         => "users#new"
  post "signup"        => "users#create"
  get "choose_signup"  => "sessions#choose_signup"
  get "account"        => "users#account"
  
  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure"            => "sessions#failure"
end
