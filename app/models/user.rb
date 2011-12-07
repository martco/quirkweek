class User < ActiveRecord::Base

  has_many :users_missions, :dependent => :destroy,
                            :order     => "created_at DESC"

  has_many :missions, :through => :users_missions,
                      :source  => :mission
  
  attr_accessor :password
  attr_accessor :password_confirmation
  
	
	EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
	
	validates_presence_of :name, :message => "Enter your name"
	validates_length_of   :name, :within => 2..30, :too_long => "Name is too long, maximum is 30 characters",
	                                             :too_short => "Name is too short, minimum is 2 characters"

	
	validates_presence_of   :email, :message => "Enter an email"
	validates_uniqueness_of :email, :message => "This email is already taken"
	validates_length_of     :email, :maximum => 50, :message => "Email should be less than 50 characters long"

	validates_format_of :email, :with => EMAIL_REGEX, :message => "Enter a valid email format"

	validate            :password_must_be_present
	validates_length_of :password, :minimum => 5, :message => "Password minimum is 5 characters", :allow_nil => true  #allow_nil is here for a reason
	validates_length_of :password, :maximum => 30, :message => "Password maximum is 30 characters", :allow_nil => true  #allow_nil is here for a reason
	
	validate                  :password_confirmation_must_be_present
	validates_confirmation_of :password, :message => "Passwords do not match", :if => :password_should_change
	
	before_save :create_hashed_password, :downcase_email
	after_save  :clear_password
	
  attr_protected :hashed_password, :salt
	
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
		
	#authentication methods below
	
	def self.make_salt(email="")
    Digest::SHA1.hexdigest("Take #{email} with #{Time.now} to make salt")
  end
	
  def self.hash_with_salt(password="", salt="")
    Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
  end
    
  def self.authenticate(email="", password="")
    user = User.find_by_email(email)
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
    unless password.blank? #if there is a password it is changed
      self.salt = User.make_salt(email) if salt.blank?
      self.hashed_password = User.hash_with_salt(password, salt)
    end
  end
  
  def clear_password
    self.password = nil
    self.password_confirmation = nil
  end
  
  #authentication methods are above this line
  
  
  
end
