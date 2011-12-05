class MissionsController < ApplicationController
  
  def index
    @mission = Mission.first #manually created
    @user = User.first       #manually created
    @quirks = UsersMission.limit(10)
  end
  
end
