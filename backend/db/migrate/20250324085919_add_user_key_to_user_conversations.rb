class AddUserKeyToUserConversations < ActiveRecord::Migration[7.2]
  def change
    add_reference :user_conversations, :user_key, default: false, foreign_key: true
  end
end
