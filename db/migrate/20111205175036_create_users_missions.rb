class CreateUsersMissions < ActiveRecord::Migration
  def change
    create_table :users_missions do |t|
      t.integer "user_id",    :null    => false
      t.integer "mission_id", :null => false

      t.string "text"
      t.string "location"
      
      t.timestamps
    end
    add_index("users_missions", "user_id")
    add_index("users_missions", "mission_id")
  end
end
