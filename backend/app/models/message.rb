# frozen_string_literal: true

class Message < ApplicationRecord 
  attr_accessor :conversation_uuid

  encrypts :content

  belongs_to :user_conversation
  belongs_to :user

  validates :conversation_uuid, presence: true, on: :create

  before_validation :link_conversation, on: :create

  private

  def link_conversation
    self.user_conversation = UserConversation.find_by_uuid(conversation_uuid)
  end
end
