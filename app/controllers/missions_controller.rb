class MissionsController < ApplicationController
  
  def index
    @mission        = Mission.first #manually created
    @user           = User.first       #manually created
    @quirks         = UsersMission.limit(10)
    @featured_quirk = @quirks.first
    @title          = "quirk it!"
    @comment        = Comment.new
  end
  
end
