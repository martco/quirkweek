module UsersHelper
  
  def print_error(attribute)
    @user.errors.messages[:"#{attribute}"] ? "error" : ""
  end
  
  def first_error(attribute)
    @user.errors.messages[:"#{attribute}"].first if @user.errors.messages[:"#{attribute}"]
  end
  
  def user_has_authentication(attribute)
    current_user.authentications.each do |a|
      if a.provider == "#{attribute}"
        return true
      end
    end
    return false
  end
  
end
