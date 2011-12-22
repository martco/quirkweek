class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "name"
      t.string "username"
      t.string "email"
      t.boolean "just_social", :default => false
      t.string "hashed_password"
      t.string "salt"

      #user.photo
      t.string "photo_file_name"
      t.string "photo_content_type"
      t.integer "photo_file_size"
      t.datetime "photo_updated_at"
      
      t.timestamps
    end
  end
end
