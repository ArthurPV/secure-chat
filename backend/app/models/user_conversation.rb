# frozen_string_literal: true

class UserConversation < ApplicationRecord
  has_and_belongs_to_many :users
  has_one :user_key
  has_many :messages
end
