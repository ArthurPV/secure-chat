class UserContacted < ApplicationRecord
  belongs_to :user
  belongs_to :user_contact

  validates :user, presence: true, uniqueness: { scope: :user_contact }
  validate :user_contacted_count

  after_destroy :remove_contact

  private

  def user_contacted_count
    errors.add(:user_contacteds, "You can only have 2 user contacteds per contact") if user_contact.user_contacteds.count > 2
  end

  def remove_contact
    if user_contact.user_contacteds.count == 1
      user_contact.user_contacteds.first.destroy!
    elsif user_contact.user_contacteds.count.zero?
      user_contact.destroy!
    end
  end
end
