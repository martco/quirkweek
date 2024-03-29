class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer "user_id",          :null => false
      t.integer "users_mission_id", :null => false
      
      t.string "text"
      t.timestamps
    end
    add_index("comments", "users_mission_id")
    add_index("comments", "user_id")    
  end
end
