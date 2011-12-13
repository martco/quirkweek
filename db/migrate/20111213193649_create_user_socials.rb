class CreateUserSocials < ActiveRecord::Migration
  def change
    create_table :user_socials do |t|
      t.string "provider"  
      t.string "uid"
      t.string "name"
      
      t.timestamps
    end
  end
end
