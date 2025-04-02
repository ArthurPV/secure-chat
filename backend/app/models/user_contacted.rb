class UserContacted < ApplicationRecord
  attr_accessor :contacted_uuid

  belongs_to :user
  belongs_to :user_contact

  validates :user, presence: true, uniqueness: { scope: :contact }
  validate :user_contacted_count

  after_destroy :remove_contact

  validates :contacted_uuid, presence: true, on: :create

  before_validation :set_contacted, on: :create

  private

  def user_contacted_count
    errors.add(:user_contacteds, "You can only have 2 user contacteds per contact") if contact.contacteds.count > 2
  end

  def remove_contact
    if contact.contacteds.count == 1
      contact.contacteds.first.destroy!
    elsif contact.contacteds.count.zero?
      contact.destroy!
    end
  end

  def set_contacted
    self.contacted = User.find_by_uuid(contacted_uuid)
  end
end
