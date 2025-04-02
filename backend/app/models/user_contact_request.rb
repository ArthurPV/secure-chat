class UserContactRequest < ApplicationRecord
  include UuidConcern

  belongs_to :user
  belongs_to :contacted, class_name: "User", foreign_key: "contacted_id"

  validates :user, presence: true, uniqueness: { scope: :contacted }
end
