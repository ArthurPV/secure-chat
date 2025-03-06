class ApplicationController < ActionController::API
  before_action :authenticate

  private

  def authenticate
    token = request.authorization&.gsub("Bearer ", "")
    entire_payload = AuthJwt.decode(token) if token

    head :unauthorized unless find_user(entire_payload)
  end

  def find_user(entire_payload)
    return nil unless entire_payload

    payload = entire_payload[:payload]
    user_jti = UserJti.find_by(jti: payload["jti"])

    set_current_user_jti(user_jti)
    revoke_user_jti!(user_jti)

    Current.user
  end

  def set_current_user_jti(user_jti)
    return unless user_jti

    Current.user_jti = user_jti
  end

  def revoke_user_jti!(user_jti)
    return if Current.user

    user_jti&.destroy!
  end
end
