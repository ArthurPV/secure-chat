class ChangeUserKeyInUserConversations < ActiveRecord::Migration[7.2]
  def change
    change_column_null :user_conversations, :user_key_id, false
    change_column_default :user_conversations, :user_key_id, from: 0, to: nil
  end
end
