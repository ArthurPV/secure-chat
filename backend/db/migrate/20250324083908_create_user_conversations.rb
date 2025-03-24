class CreateUserConversations < ActiveRecord::Migration[7.2]
  def change
    create_table :user_conversations do |t|
      t.timestamps
    end
  end
end
