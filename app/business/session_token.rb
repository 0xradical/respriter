class SessionToken
  attr_reader :token, :ip

  def initialize(token, ip)
    @token, @ip = token, ip
  end

  def encrypt
    cipher = OpenSSL::Cipher::AES.new 128, :ECB
    cipher.encrypt
    cipher.key = ENV.fetch 'USER_SESSION_TOKEN_KEY'

    payload = {
      token:     @token,
      expire_at: 1.minute.from_now.to_i,
      ip:        @ip
    }.to_json

    Base64.encode64( cipher.update(payload) + cipher.final )
  end

  def self.decrypt(payload, ip)
    cipher = OpenSSL::Cipher::AES.new 128, :ECB
    cipher.decrypt
    cipher.key = ENV.fetch 'USER_SESSION_TOKEN_KEY'

    json_payload = cipher.update(Base64.decode64(payload)) + cipher.final

    params = JSON.parse(json_payload).deep_symbolize_keys
    if ip == params[:ip] && Time.at(params[:expire_at]) > Time.now
      params[:token]
    else
      raise 'Invalid Token'
    end
  rescue OpenSSL::Cipher::CipherError
    raise 'Invalid Token'
  end
end
