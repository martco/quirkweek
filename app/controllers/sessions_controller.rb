class SessionsController < ApplicationController
  
  # social accounts methods
  def create
    user_social              = UserSocial.from_omniauth(env["omniauth.auth"])
    session[:user_social_id] = user_social.id
    redirect_to root_url, :notice => "Signed in with Twitter!"
  end
  
  #this should be removed shortly
  def destroy
    session[:user_social_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
  
  def failure
    redirect_to root_url,  :alert => "Authentication failed, please try again."
  end

  
  # classic account methods
  def login
    @title = "Login"
  end
  
  def attempt_login
    authorized_user = User.authenticate(params[:username], params[:password])
    if authorized_user
      sign_in authorized_user
      redirect_to root_path, :notice => "Hello #{authorized_user.username}, welcome back!"
    else
      redirect_to login_path, :alert => "Wrong email or password"
    end
  end
  
  def signout
    sign_out
    redirect_to login_path, :notice => "You have logged out"
  end
  
    
end
