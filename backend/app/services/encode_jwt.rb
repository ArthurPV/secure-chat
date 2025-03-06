class EncodeJwt
  attr_accessor :payload, :exp, :secret, :alg, :aud

  def initialize(payload:, exp:, secret:, alg:, aud:)
    self.payload = payload
    self.exp = exp
    self.secret = secret
    self.alg = alg
    self.aud = aud
  end

  def run
    self.payload["exp"] = self.exp.to_i
    self.payload["aud"] = self.aud

    JWT.encode(self.payload, self.secret, self.alg)
  end
end
