class RenameUserKeysToUserConversationKeys < ActiveRecord::Migration[7.2]
  def change
    rename_table :user_keys, :user_conversation_keys
  end
end
