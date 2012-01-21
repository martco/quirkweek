Quirkweek::Application.routes.draw do

  root :to => 'missions#index'

  resources :missions
  resources :comments
  
  get "login"               => "sessions#login"
  get "logout"              => "sessions#signout"
  post "attempt_login"      => "sessions#attempt_login"
    
  get "signup"                      => "users#new"
  post "signup"                     => "users#create"
  delete "users"                    => "users#destroy"
  
  get "password_authentication"     => "users#password_authentication"
  put "add_password_authentication" => "users#add_password_authentication"
  get "account"                     => "users#account"
  
  get "choose_signup"        => "sessions#choose_signup"
  post "create_twitter_user" => "sessions#create_twitter_user"
  
  match "/auth/:provider/callback" => "sessions#create"
  match "/auth/failure"            => "sessions#failure"

end
