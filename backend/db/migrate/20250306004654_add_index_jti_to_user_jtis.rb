class AddIndexJtiToUserJtis < ActiveRecord::Migration[7.2]
  def change
    add_index :user_jtis, :jti, unique: true
  end
end
