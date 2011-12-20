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
  
  
	#EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
	USERNAME_REGEX = /^[A-Z0-9]+$/i
	PASSWORD_REGEX = /^[A-Z0-9]+$/i
	PASSWORD_CHARACTER_REGEX = /[A-Z]/i
	PASSWORD_NUMBER_REGEX = /[0-9]/i


	validates_presence_of   :name, :message => "Enter your name"
	#validates_length_of     :name, :within => 4..30, :message => "Name should be between 4 and 30 characters long."
	
	validates_presence_of   :username, :message => "Enter your username"
	validates_uniqueness_of :username, :message => "This username is already taken"
	validates_format_of     :username, :with   => USERNAME_REGEX, :message => "Username can contain only letters and numbers"
	validates_length_of     :username, :within => 6..15, :message => "Should be between 6 and 15 characters long"
  validate                :username_must_not_be_vulgar
  validate                :username_more_letters_than_numbers
	
	# validates_presence_of   :email, :message => "Enter an email"
	# validates_uniqueness_of :email, :message => "This email is already taken"
	# validates_length_of     :email, :maximum => 50, :message => "Email should be less than 50 characters long"
	# 
	# validates_format_of :email, :with => EMAIL_REGEX, :message => "Enter a valid email format"
	
	validate            :password_must_be_present
	validate            :password_not_equal_to_username
	validates_length_of :password, :minimum => 6,  :message => "Password minimum is 6 characters", :allow_nil => true  #allow_nil is here for a reason
	validates_length_of :password, :maximum => 15, :message => "Password maximum is 15 characters", :allow_nil => true  #allow_nil is here for a reason
	validates_format_of :password, :with    => PASSWORD_REGEX,           :message => "Password can contain only letters and numbers", :if => :password_should_change
	validates_format_of :password, :with    => PASSWORD_CHARACTER_REGEX, :message => "Password needs to include at least one letter", :if => :password_should_change
	validates_format_of :password, :with    => PASSWORD_NUMBER_REGEX,    :message => "Password needs to include at least one number", :if => :password_should_change
	
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
	    errors.add(:password, "Missing password confirmation") unless password_confirmation.present?
	  end
	end
	
	def password_should_change
	  password.present? ? true : false
	end
	
	def password_not_equal_to_username
	  errors.add(:password, "Password cannot be the same as username") if password.present? && password == username
	end
	
	def username_must_not_be_vulgar
	  errors.add(:username, "Username must not be vulgar") if ProfanityFilter::Base.profane?(username)
	end
	
	def username_more_letters_than_numbers
	  if username                                         # if there is no username - gsub throws error
	    letters     = username.gsub(/[^a-zA-Z]/, '').size   # deletes non-letters and counts the rest
	    non_letters = username.gsub(/[a-zA-Z]/, '').size    # deletes the letters and counts the rest
	    errors.add(:username, "Username cannot contain more numbers than letters") if non_letters > letters
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

