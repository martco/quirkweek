class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :users_mission
  
  validates_presence_of :user_id
  validates_presence_of :users_mission_id
  validates_presence_of :text
end
# == Schema Information
#
# Table name: comments
#
#  id               :integer         not null, primary key
#  user_id          :integer         not null
#  users_mission_id :integer         not null
#  text             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

