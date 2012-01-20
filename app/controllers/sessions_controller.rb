class SessionsController < ApplicationController
  
  # social accounts methods
  def create
    #render :text => env["omniauth.auth"].to_yaml
    omniauth       = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
  
    if authentication
      sign_in authentication.user      # signs in with basic user
      redirect_to root_url, :notice => "Signed in successfully via #{omniauth['provider'].capitalize}"
    

    elsif signed_in?                        # basic user exists, just add new authentication
      if current_user.just_social           # cannot add another social account if the acc is just social
        redirect_to account_path, :alert => "You cannot add another social network before authenticating with username & password."
      else
        unless current_user.has_authentication?(omniauth['provider'])       # cannot add another social account of the same type (2 twitter accounts)
          current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
          redirect_to account_path, :notice => "Successfully added authentication!"
        else
          redirect_to account_path, :alert => "You cannot add two #{omniauth['provider'].capitalize} accounts."
        end
      end


    # this is first social sign-in, basic user has to be created
    elsif omniauth['provider'] != 'twitter'              # no age check needs to be done for facebook 
      user = User.create_from_authentication(omniauth, 20.years.ago)   # the other parameter is hardcoded value

      create_authentication_and_sign_in(user, omniauth)

    # new twitter user. They need to confirm their age first
    else
      twitter_confirm_age(omniauth)
    end
  end


  def twitter_confirm_age(omniauth)
    @twitter_info = omniauth.to_yaml   #serializes omniauth object
    @title = "confirm age"
    render 'twitter_confirm_age'
  end
  
  def create_twitter_user
    b = params[:user]
    birthdate = DateTime.new(b["birthdate(1i)"].to_i, b["birthdate(2i)"].to_i, b["birthdate(3i)"].to_i)   # creates birthdate object
    omniauth = YAML::load(params[:omniauth])   # deserializes omniauth string from params
    
    # user is older than 13 - create account
    if birthdate < 13.years.ago
      user = User.create_from_authentication(omniauth, birthdate)
      create_authentication_and_sign_in(user, omniauth)
    
    # user is less than 13 yo
    else
      redirect_to root_url, :alert => "You must be over 13 years old to create an account!"
    end
  end


  def create_authentication_and_sign_in(user, omniauth)
    if user.valid?
      user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      sign_in user
      redirect_to root_url, :notice => "Successful authentication via #{omniauth['provider'].capitalize}"
    else
      redirect_to root_url, :alert => "Unsuccessful user creation! Error: #{user.errors.first}"
    end
  end
  
  def failure
    redirect_to root_url,  :alert => "Authentication failed, please try again."
  end

  
  # classic account methods
  def login
    @title = "Log in"
  end
  
  def choose_signup
    @title = "Sign up"
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
