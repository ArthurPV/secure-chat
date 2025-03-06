class Current < ActiveSupport::CurrentAttributes
  attribute :user_jti
  attribute :user

  def user_jti=(user_jti)
    super
    self.user = user_jti.user
  end
end
