module UsersHelper
  
  def print_error(attribute)
    @user.errors.messages[:"#{attribute}"] ? "error" : ""
  end
  
  def first_error(attribute)
    @user.errors.messages[:"#{attribute}"].first if @user.errors.messages[:"#{attribute}"]
  end
end
