# frozen_string_literal: true

class UserConversation < ApplicationRecord
  include UuidConcern

  attr_accessor :public_key, :private_key
  attr_accessor :participants

  has_and_belongs_to_many :users
  has_one :user_conversation_key, autosave: true, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :public_key, presence: true, on: :create
  validates :private_key, presence: true, on: :create
  validates :participants, presence: true, on: :create

  before_create :create_user_conversation_key
  before_create :link_participants

  private

  def create_user_conversation_key
    self.user_conversation_key = UserConversationKey.new(public_key:, private_key:)
  end

  def link_participants
    participants.each do |participant|
      self.users << User.find_by_uuid(participant)
    end
  end
end
