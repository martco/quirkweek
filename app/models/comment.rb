class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :users_mission
  
  validates_presence_of :user_id
  validates_presence_of :users_mission_id
  validates_presence_of :text
end
