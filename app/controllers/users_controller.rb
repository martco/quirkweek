class UsersController < ApplicationController

  def new      #get signup
    @title = "Sign up"
    @user = User.new
  end

  def create    #post signup
    @user = User.new(params[:user])
    if @user.valid?
      @user.save
      sign_in @user
      redirect_to root_path, :notice => "Hello, welcome to Quirkweek!"
    else
      @title = "Sign up"
      flash.now[:alert] = "Wrong input"
      render 'new'
    end
  end

  def update    #users/update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_path, :notice => "Your profile has been updated"
    else
      redirect_to root_path, :alert => "Error - profile not updated"
    end
  end
  
  def account
    
  end
  
end
