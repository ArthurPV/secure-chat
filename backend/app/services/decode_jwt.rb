class DecodeJwt
  attr_accessor :token, :secret, :alg, :aud

  def initialize(token:, secret:, alg:, aud:)
    self.token = token
    self.secret = secret
    self.alg = alg
    self.aud = aud
  end

  def run!
    JWT.decode(token, secret, true, { verify_expiration: true, algorithm: self.alg, aud: self.aud })
  end
end
