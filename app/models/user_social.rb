class UserSocial < ActiveRecord::Base

  def self.from_omniauth(auth)
    # find the already registered user OR creates a new one
    find_by_provider_and_uid(auth["provider"], auth["uid"]) || create_with_omniauth(auth)
  end
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid      = auth["uid"]
      user.name     = auth["info"]["name"]
    end
  end
end
