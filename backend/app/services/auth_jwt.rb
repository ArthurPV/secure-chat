class AuthJwt
  MAX_EXPIRATION = 2.weeks.from_now.freeze
  SECRET = Rails.application.credentials.auth_jwt_secret_key!
  ALG = "HS256"
  AUD = "secure-chat"

  def self.encode!(user)
    user_jti = user.user_jtis.create!

    EncodeJwt.new(payload: { jti: user_jti.jti }, exp: MAX_EXPIRATION, secret: SECRET, alg: ALG, aud: AUD).run
  end

  def self.decode(token)
    begin
      entire_payload = DecodeJwt.new(token:, secret: SECRET, alg: ALG, aud: AUD).run!

      { payload: entire_payload[0], header: entire_payload[1] }
    rescue _e
      nil
    end
  end
end
