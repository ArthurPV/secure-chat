class UserContact < ApplicationRecord
  include UuidConcern

  enum :status, { accepted: 0, blocked: 1 }

  has_many :user_contacteds
  has_many :contacteds, through: :user_contacteds
end
