class Mission < ActiveRecord::Base

  has_many :users_missions, :dependent => :destroy,
                            :order => "created_at DESC"

  has_many :users, :through => :users_missions
                   :source => :user
                            
  validates_presence_of :title, :message => "A mission should have a title"
  #validates_uniqueness_of :title, :message => "The mission with the same title already exists"
  # the line above disables duplicate mission titles
  validates_length_of :title, :maximum => 30, :message => "Title maximum length is 30 characters"
  
  validates_presence_of :description
  validates_presence_of :beginning
  validates_presence_of :end

end
