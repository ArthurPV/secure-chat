# frozen_string_literal: true

class Message < ApplicationRecord
  encrypts :content

  belongs_to :user_conversation
end
