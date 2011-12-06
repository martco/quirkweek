class CreateMissions < ActiveRecord::Migration
  def change
    create_table :missions do |t|
      t.string "title"
      t.text "description"
      t.datetime "beginning"
      t.datetime "end"

      t.timestamps
    end
  end
end
