class UserContactRequest < ApplicationRecord
  attr_accessor :contacted_uuid

  include UuidConcern

  belongs_to :user
  belongs_to :contacted, class_name: "User", foreign_key: "contacted_id"

  validates :user, presence: true, uniqueness: { scope: :contacted }
  validates :contacted_uuid, presence: true, on: :create
  validate :contact_exists, on: :create

  before_validation :set_contacted, on: :create

  private

  def set_contacted
    self.contacted = User.find_by_uuid(contacted_uuid)
  end

  def contact_exists
    user_contacteds = UserContacted.where(user_id: [ user_id, contacted_id ])
    user_contacted_1 = user_contacteds.first
    user_contacted_2 = user_contacteds.second

    return unless user_contacted_1 && user_contacted_2 && user_contacted_1&.user_contact&.id == user_contacted_2&.user_contact&.id

    errors.add(:base, "You cannot create a request of contact when an actual contact with the contacted already exists")
  end
end
