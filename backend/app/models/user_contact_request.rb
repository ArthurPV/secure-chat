class UserContactRequest < ApplicationRecord
  attr_accessor :contacted_uuid

  include UuidConcern

  belongs_to :user
  belongs_to :contacted, class_name: "User", foreign_key: "contacted_id"

  validates :user, presence: true, uniqueness: { scope: :contacted }
  validates :contacted_uuid, presence: true, on: :create

  before_validation :set_contacted, on: :create

  private

  def set_contacted
    self.contacted = User.find_by_uuid(contacted_uuid)
  end
end
