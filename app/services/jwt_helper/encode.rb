class JwtHelper::Encode

  HMAC_SECRET = Settings.jwt_secret

  attr_reader :payload

  def self.call(*args)
    new(*args).call
  end

  def initialize(payload)
    @payload = payload
  end

  def call
    token = JWT.encode payload, HMAC_SECRET, 'HS256'
    token
  end

end
