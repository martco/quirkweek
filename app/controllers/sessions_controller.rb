class SessionsController < ApplicationController
  
  # social accounts methods
  def create
    #render :text => env["omniauth.auth"].to_yaml

    omniauth       = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
  
    if authentication
      sign_in authentication.user      # signs in with basic user
      redirect_to root_url, :notice => "Signed in successfully via #{omniauth['provider'].capitalize}"
    
    elsif signed_in?  # basic user exists, just add new authentication
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      redirect_to root_url, :notice => "Successfully added authentication!"
    
    else              # this is first social sign-in, basic user has to be created
      user = User.create_from_authentication(omniauth)
      redirect_to root_url, :notice => "I successfully came here!"
      #user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      #sign_in user
      #redirect_to root_url, :notice => "Successful authentication via #{omniauth['provider'].capitalize}"
    end
  end

  
  def failure
    redirect_to root_url,  :alert => "Authentication failed, please try again."
  end

  
  # classic account methods
  def login
    @title = "Login"
  end
  
  def choose_signup
  end
  
  def attempt_login
    authorized_user = User.authenticate(params[:username], params[:password])
    if authorized_user
      sign_in authorized_user
      redirect_to root_path, :notice => "Hello #{authorized_user.first_name}, welcome back!"
    else
      redirect_to login_path, :alert => "Wrong email or password"
    end
  end
  
  def signout
    sign_out
    redirect_to root_path, :notice => "You have logged out"
  end
  
    
end
