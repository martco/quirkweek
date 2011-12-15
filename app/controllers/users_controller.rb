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
      redirect_to root_path, :notice => "Hello, welcom to Quirkweek!"
    else
      @title = "Sign up"
      flash[:notice] = "Wrong input"
      render 'new'
    end
  end

  def update    #users/update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_path, :notice => "Your profile has been updated"
    else
      redirect_to root_path, :notice => "Error - profile not updated"
    end
  end
  
end
