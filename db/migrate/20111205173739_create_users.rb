class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "name"
      t.string "username"
      t.string "email"
      t.boolean "just_social", :default => false
      t.string "hashed_password"
      t.string "salt"

      
      t.timestamps
    end
  end
end
