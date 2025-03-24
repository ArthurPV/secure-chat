# frozen_string_literal: true

class Message < ApplicationRecord
  attr_accessor :conversation

  encrypts :content

  belongs_to :user_conversation
  belongs_to :user

  validates :conversation, presence: true, on: :create

  before_validation :link_conversation, if: :new_record?

  private

  def link_conversation
    self.user_conversation = UserConversation.find_by_uuid(conversation)
  end
end
