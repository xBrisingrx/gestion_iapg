require "jwt"

module JsonWebToken
  extend ActiveSupport::Concern
  # SECRET_KEY = Rails.application.secrets.secret_key_base
  PRIVATE_KEY = OpenSSL::PKey::RSA.new(File.read(Rails.root.join("config/keys/private.pem")))
  PUBLIC_KEY = OpenSSL::PKey::RSA.new(File.read(Rails.root.join("config/keys/public.pem")))
  def jwt_encode(payload, exp = 7.days.from_now)
    JWT.encode(payload, PRIVATE_KEY, "RS256")
  end

  def jwt_decode(token)
    if token
      begin
        decoded_token = JWT.decode(token, PUBLIC_KEY, true, { algorithm: "RS256" })
        payload = decoded_token.first
      rescue JWT::ExpiredSignature
        puts "El token ha expirado"
      rescue JWT::DecodeError => e
        puts "Token inválido: #{e.message}"
      end
    end
  end
end
