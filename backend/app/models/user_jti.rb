# frozen_string_literal: true

class UserJti < ApplicationRecord
  belongs_to :user

  before_validation :set_jti

  validates :jti, presence: true, uniqueness: true

  private

  def set_jti
    self.jti = SecureRandom.uuid
  end
end
