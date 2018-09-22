class JwtHelper::Decode

  HMAC_SECRET = Settings.jwt_secret

  attr_reader :token, :decoded_token, :payload, :header

  def self.call(*args)
    new(*args).call
  end

  def initialize(token)
    @token = token
    @decoded_token
    @payload
    @header
  end

  def call
    @decoded_token = JWT.decode token, HMAC_SECRET, true, { algorithm: 'HS256' }
    @payload = @decoded_token[0]
    @header = @decoded_token[1]
    self
  end

end
