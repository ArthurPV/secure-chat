class AddUserConversationToUserKeys < ActiveRecord::Migration[7.2]
  def change
    add_reference :user_keys, :user_conversation, null: false, foreign_key: true
  end
end
