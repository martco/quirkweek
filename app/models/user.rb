class User < ActiveRecord::Base

  include ProfanityFilter

  has_many :users_missions, :dependent => :destroy,
                            :order     => "created_at DESC"

  has_many :missions, :through => :users_missions,
                      :source  => :mission
  
  has_many :comments, :dependent => :destroy,
                      :order     => "created_at DESC"
  
  has_many :authentications, :dependent => :destroy
  
  attr_accessor :password
  attr_accessor :password_confirmation
  
  has_attached_file :photo, :styles          => {:original => ["50x", :jpg]},       # this resizes to width of 50px
	                          :convert_options => { :original => '-crop 50x50+0+0'},  # this cropps to dimensions of 50x50 px
	                          :url             => "/assets/user_photos/:style/photo:id.:extension",
	                          :path            => ":rails_root/assets/user_photos/:style/photo:id.:extension",
	                          :default_url     => "/assets/default_user_photo.jpg"
	                          
	                          #:storage => :s3,
	                          #:s3_credentials => "#{Rails.root}/config/s3.yml",
	                          #:path => ":attachment/:id/img.:extension",  #path: photo/34/img.png,
	                          #:bucket => 'choose bucket'

	
  #validates_attachment_size :photo, :less_than => 2.megabytes, :message => "The photo has to be smaller than 2Mb"
  #validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], :message => "The photo has to be jpg, gif or png"
  
  
	EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
	USERNAME_REGEX = /^[A-Z0-9]+$/i
	PASSWORD_REGEX = /^[A-Z0-9]+$/i
	PASSWORD_CHARACTER_REGEX = /[A-Z]/i
	PASSWORD_NUMBER_REGEX = /[0-9]/i


	validates_presence_of   :name, :message => "Please create a name."
	#validates_length_of     :name, :within => 4..30, :message => "Name should be between 4 and 30 characters long."
	
	validates_presence_of   :username, :message => "Please create a username."
	validates_uniqueness_of :username, :message => "Sorry, that username is already taken."
	validates_format_of     :username, :with   => USERNAME_REGEX, :message => "Sorry, a username may contain only letters and numbers."
	validates_length_of     :username, :within => 6..15, :message => "Sorry, a username must be between 6 and 15 characters long."
  validate                :username_must_not_be_vulgar
  validate                :username_more_letters_than_numbers
	
  validates_presence_of   :email, :message => "Please enter an email."
  validates_uniqueness_of :email, :message => "This email is already taken."
  validates_length_of     :email, :maximum => 50, :message => "Sorry, your email must be no more than 50 characters long."
  validates_format_of     :email, :with => EMAIL_REGEX, :message => "Sorry, email format is not correct."
	
	validate            :password_must_be_present
	validate            :password_not_equal_to_username
	validates_length_of :password, :minimum => 6,  :message => "Sorry, your password must be at least 6 characters long.", :allow_nil => true  #allow_nil is here for a reason
	validates_length_of :password, :maximum => 15, :message => "Sorry, your password must be no more than 15 characters long.", :allow_nil => true  #allow_nil is here for a reason
	validates_format_of :password, :with    => PASSWORD_REGEX,           :message => "Sorry, your password may contain only letters and numbers.", :if => :password_should_change
	validates_format_of :password, :with    => PASSWORD_CHARACTER_REGEX, :message => "Sorry, your password needs to include at least one letter.", :if => :password_should_change
	validates_format_of :password, :with    => PASSWORD_NUMBER_REGEX,    :message => "Sorry, your password needs to include at least one number.", :if => :password_should_change
	
	validate                  :password_confirmation_must_be_present
	validates_confirmation_of :password, :message => "Sorry, your passwords do not match.", :if => :password_should_change
	
	before_save :create_hashed_password, :downcase_email
	after_save  :clear_password
	
  attr_protected :hashed_password, :salt
	
	# validation methods	
	def password_must_be_present
	  if password_confirmation.present?
	    errors.add(:password, "Password missing!") unless password.present? # error on password update
	  else
	    errors.add(:password, "Password missing!") unless hashed_password.present? || password.present? # error on user creation
	  end
	end
	
	def password_confirmation_must_be_present
	  if password.present?
	    errors.add(:password, "Please re-type your password for confirmation.") unless password_confirmation.present?
	  end
	end
	
	def password_should_change
	  password.present? ? true : false
	end
	
	def password_not_equal_to_username
	  errors.add(:password, "Sorry, your password cannot be the same as your username.") if password.present? && password == username
	end
	
	def username_must_not_be_vulgar
	  errors.add(:username, "Sorry, that username violates our Terms of Service. Please create another.") if ProfanityFilter::Base.profane?(username)
	end
	
	def username_more_letters_than_numbers
	  if username                                         # if there is no username - gsub throws error
	    letters     = username.gsub(/[^a-zA-Z]/, '').size   # deletes non-letters and counts the rest
	    non_letters = username.gsub(/[a-zA-Z]/, '').size    # deletes the letters and counts the rest
	    errors.add(:username, "Sorry, a username cannot contain more numbers than letters.") if non_letters > letters
    end
	end
	
	# regular 'helper' method
	def first_name
	  self.name.split[0].capitalize
	end
	
	def has_authentication?(authentication)
    self.authentications.each do |a|
      return true if a.provider == authentication
    end
    return false
  end
	
		
	#authentication methods below
	
	def self.make_salt(username="")
    Digest::SHA1.hexdigest("Take #{username} with #{Time.now} to make salt")
  end
	
  def self.hash_with_salt(password="", salt="")
    Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
  end
    
  def self.authenticate(username="", password="")
    user = User.find_by_username(username)
    if user && user.password_match?(password)
      return user
    else
      return false
    end
  end
    
  def password_match?(password="")
    hashed_password == User.hash_with_salt(password, salt)
  end
  
  def downcase_email
    self.email = self.email.downcase
  end


  private

  def create_hashed_password
    unless password.blank?     #if there is a password it is updated
      self.salt = User.make_salt(username) if salt.blank?
      self.hashed_password = User.hash_with_salt(password, salt)
    end
  end
  
  def clear_password
    self.password = nil
    self.password_confirmation = nil
  end
  
  #authentication methods are above this line
  

  # methods for integrating with social accounts
  
  def self.create_from_authentication(omniauth)
    dummy_password = SecureRandom.hex(5) + "A0"   # dummy password just that user validation can pass
    username       = Array.new(10) { (rand(122-97) + 97).chr }.join  
    # makes unique 10-char random string
    # facebook may not have username so cannot take the omniauth['info']['nickname'] from omniauth response
    
    
    if omniauth['provider'] == 'twitter'
      if defined?(omniauth['info']['nickname'])
        name = omniauth['info']['nickname']
      else
        name = "NoName"
      end

    elsif omniauth['provider'] == 'facebook'
      if defined?(omniauth['info']['first_name'])
        name = omniauth['info']['first_name']
      else
        name = "NoName"
      end

    else      # unknown omniauth authorization
      name = "NoName"
    end
    
    User.create(:name => name,
                    :username              => username,
                    :just_social           => true,
                    :password              => dummy_password, 
                    :password_confirmation => dummy_password)

    ### The below is to be deleted
    # if user.valid?
    #   user.save
    # else
    #   user.name = "Whatever"
    #   user.save
    # end
    # 
    # return user
  end
  
end
# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  hashed_password :string(255)
#  salt            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

