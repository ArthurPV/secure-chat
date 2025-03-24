class AddUuidToUserConversations < ActiveRecord::Migration[7.2]
  def change
    add_column :user_conversations, :uuid, :uuid, default: "gen_random_uuid()", null: false
  end
end
