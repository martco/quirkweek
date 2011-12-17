class User < ActiveRecord::Base

  has_many :users_missions, :dependent => :destroy,
                            :order     => "created_at DESC"

  has_many :missions, :through => :users_missions,
                      :source  => :mission
  
  has_many :comments, :dependent => :destroy,
                      :order     => "created_at DESC"
  
  has_many :authentications, :dependent => :destroy
  
  attr_accessor :password
  attr_accessor :password_confirmation
  
	
	#EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
	USERNAME_REGEX = /^[A-Z0-9._-]+$/i

	validates_presence_of   :name, :message => "Enter your name"
	validates_length_of     :name, :within => 4..30, :message => "Name should be between 4 and 30 characters long."
	
	validates_presence_of   :username, :message => "Enter your username"
	validates_uniqueness_of :username, :message => "This username is already taken"
	validates_format_of     :username, :with   => USERNAME_REGEX, :message => "Username can have only . _ -"
	validates_length_of     :username, :within => 4..15, :message => "Username should be between 4 and 15 characters long."

	
	# validates_presence_of   :email, :message => "Enter an email"
	# validates_uniqueness_of :email, :message => "This email is already taken"
	# validates_length_of     :email, :maximum => 50, :message => "Email should be less than 50 characters long"
	# 
	# validates_format_of :email, :with => EMAIL_REGEX, :message => "Enter a valid email format"
	
	validate            :password_must_be_present
	validates_length_of :password, :minimum => 5,  :message => "Password minimum is 5 characters", :allow_nil => true  #allow_nil is here for a reason
	validates_length_of :password, :maximum => 30, :message => "Password maximum is 30 characters", :allow_nil => true  #allow_nil is here for a reason
	
	validate                  :password_confirmation_must_be_present
	validates_confirmation_of :password, :message => "Passwords do not match", :if => :password_should_change
	
	before_save :create_hashed_password  #, :downcase_email
	after_save  :clear_password
	
  attr_protected :hashed_password, :salt
	
	# validation methods	
	def password_must_be_present
	  if password_confirmation.present?
	    errors.add(:password, "Missing password") unless password.present? # error on password update
	  else
	    errors.add(:password, "Missing password") unless hashed_password.present? || password.present? # error on user creation
	  end
	end
	
	def password_confirmation_must_be_present
	  if password.present?
	    errors.add(:password_confirmation, "Missing password confirmation") unless password_confirmation.present?
	  end
	end
	
	def password_should_change
	  password.present? ? true : false
	end
	
	# regular 'helper' method
	def first_name
	  self.name.split[0].capitalize
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
  
  # def downcase_email
  #   self.email = self.email.downcase
  # end


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
  
  def self.create_from_authentication(name, username)
    dummy_password = SecureRandom.hex(10)   # dummy password just that user validation can pass
    valid_name     = User.make_valid_name(name)
    valid_username = User.make_valid_username(username)
    
    User.create(:name                  => valid_name,
                :username              => valid_username,
                :just_social           => true,
                :password              => dummy_password, 
                :password_confirmation => dummy_password)
  end


  def self.make_valid_username(username)  # every return adds random hex so username should always be unique
    if username.length > 11
      username = username[0..11]
    elsif username.length < 4
      username = username.ljust(4,'abcd') #fills up nickname up to 4 chars
    end
    return (username + SecureRandom.hex(2))   # adds 4 unique character for username at the end
  end

  
  def self.make_valid_name(name)
    if name.length > 30
      name = name[0..29]         # cutts of name to be 30 chars long
    elsif name.length < 4
      name = name.ljust(4, 'abcd')  # fills up name up to 4 characters
    end
    return name
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

