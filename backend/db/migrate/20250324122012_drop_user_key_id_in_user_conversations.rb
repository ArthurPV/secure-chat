class DropUserKeyIdInUserConversations < ActiveRecord::Migration[7.2]
  def change
    remove_reference :user_conversations, :user_key, foreign_key: true
  end
end
