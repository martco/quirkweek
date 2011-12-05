class UsersMission < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :mission
  
  #validates_uniqueness_of :mission_id, :scope => :user_id
  # uncomment the line above to enable just one users_mission (quirk) submission per user
  validates_presence_of :user_id
  validates_presence_of :mission_id
  
end
