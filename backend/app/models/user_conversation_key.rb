class UserConversationKey < ApplicationRecord
  encrypts :public_key
  encrypts :private_key

  belongs_to :user_conversation
end
