class AddUserConversationToMessages < ActiveRecord::Migration[7.2]
  def change
    add_reference :messages, :user_conversation, null: false, foreign_key: true
  end
end
