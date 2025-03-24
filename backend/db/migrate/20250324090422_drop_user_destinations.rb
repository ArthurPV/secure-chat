class DropUserDestinations < ActiveRecord::Migration[7.2]
  def change
    drop_table :user_destinations, if_exists: true
  end
end
