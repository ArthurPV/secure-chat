class UserKey < ApplicationRecord
  encrypts :public_key
  encrypts :private_key

  belongs_to :user
end
