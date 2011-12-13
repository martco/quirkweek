class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  private
  
  def current_user
    @current_user ||= UserSocial.find(session[:user_social_id]) if session[:user_social_id]
  end
  
end
