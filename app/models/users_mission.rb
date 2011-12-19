class UsersMission < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :mission
  
  has_many :comments, :dependent => :destroy,
                      :order     => "created_at DESC"
  
  #validates_uniqueness_of :mission_id, :scope => :user_id
  # uncomment the line above to enable just one users_mission (quirk) submission per user
  validates_presence_of :user_id
  validates_presence_of :mission_id
  
  validates_presence_of :text
  
  
  def has_comments?
    self.comments.count > 0 ? true : false
  end
  
end
# == Schema Information
#
# Table name: users_missions
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  mission_id :integer         not null
#  text       :string(255)
#  location   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

