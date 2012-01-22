class UsersController < ApplicationController

  

  def new      #get signup
    @title = "Sign up"
    @user = User.new
    @new_modal_user = User.new
  end

  def create    #post signup
    if params[:user]                     # enables the same method to handle both standard and modal user creation
      @user = User.new(params[:user])
    else
      @user = User.new(params[:new_modal_user])
    end
      
    @user.name = @user.username  # assigning the [username] to be user username
    if @user.valid?
      @user.save
      sign_in @user
      redirect_to root_path, :notice => "Hello, welcome to Quirkweek!"
    else
      @title = "Sign up"
      @new_modal_user = User.new
      flash.now[:alert] = "Wrong input"
      render 'new'
    end
  end
  
  def account
    @title = "My account"
  end
  
  def password_authentication
    @title = "Add password authentication"
    @user = current_user
  end
  
  def add_password_authentication    #users/update
    @user = current_user
    if @user.update_attributes(params[:user])
      @user.update_attributes(:just_social => false)
      redirect_to account_path, :notice => "Your profile has been updated"
    else
      @title = "Add password authentication"
      flash.now[:alert] = "Error - user not updated"
      render 'password_authentication'
    end
  end
  
  def destroy
    @user = current_user
    sign_out
    @user.destroy
    redirect_to root_path, :notice => "Your account has been deleted."
  end
  
end
