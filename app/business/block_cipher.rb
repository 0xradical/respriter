class BlockCipher

  CIPHER_IV  = "\x1C.\x85\x84\xD3\x10\xF2=\x86@\x1Ee\f\xEB\xA4c"
  CIPHER_KEY = "5S}\x12\xE9\x05W&n\xF2o\xDA\xB9\xA3\xA2\x83"

  class << self

    def encrypt(data)
      cipher = OpenSSL::Cipher::AES128.new(:CBC)
      cipher.encrypt
      cipher.key = CIPHER_KEY
      cipher.iv  = CIPHER_IV
      (cipher.update(data) + cipher.final).unpack("H*").first
    end

    def decrypt!(data)
      decoded_data = data.scan(/../).map { |x| x.hex }.pack('c*')
      decipher = OpenSSL::Cipher::AES128.new(:CBC)
      decipher.decrypt
      decipher.key = CIPHER_KEY
      decipher.iv  = CIPHER_IV
      decipher.update(decoded_data) + decipher.final
    end

  end

end
