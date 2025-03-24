class JoinUsersAndUserConversations < ActiveRecord::Migration[7.2]
  def change
    create_join_table :users, :user_conversations do |t|
      t.index [ :user_id, :user_conversation_id ]
    end
  end
end
