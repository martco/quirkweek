class SessionsController < ApplicationController
  
  def create
    user_social              = UserSocial.from_omniauth(env["omniauth.auth"])
    session[:user_social_id] = user_social.id
    redirect_to root_url, :notice => "Signed in with Twitter!"
  end
  
  def destroy
    session[:user_social_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
  
  def failure
    redirect_to root_url,  :alert => "Authentication failed, please try again."
  end
    
end
