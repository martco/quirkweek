module SessionsHelper
  
  def sign_in(authorized_user)
    cookies.permanent.signed[:user_id] = [authorized_user.id]
  end
  
  def confirm_logged_in  
    if signed_in?
      user_exists? ? true : (sign_out; redirect_to login_path, :notice => "The user doesn't exist")
    else
      if current_uri == "/"
        redirect_to welcome_path
      else
        redirect_to login_path, :notice => "Please login"
      end
    end
  end
  
  def sign_out
    cookies.delete(:user_id)
  end
  
  def signed_in?
    cookie_id ? true : false
  end
  
  def user_exists?
    User.find_by_id(cookie_id) ? true : false
  end
  
  def current_user
    User.find_by_id(cookie_id)
  end
  
  def cookie_id
    cookies.signed[:user_id] || false
  end
  
  def current_uri
    request.env['PATH_INFO']
  end
  
  
end
