Quirkweek::Application.routes.draw do

  root :to => 'missions#index'

  resources :missions
  resources :comments
  
  get "login"          => "sessions#login"
  get "logout"        => "sessions#signout"
  post "attempt_login" => "sessions#attempt_login"
    
  get "signup"         => "users#new"
  post "signup"        => "users#create"
  get "password_authentication" => "users#password_authentication"
  put "add_password_authentication" => "users#add_password_authentication"
  get "choose_signup"  => "sessions#choose_signup"
  get "account"        => "users#account"
  
  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure"            => "sessions#failure"
end
