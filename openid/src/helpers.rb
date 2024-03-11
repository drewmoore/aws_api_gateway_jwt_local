# frozen_string_literal: true

require "uri"
require "net/http"
require "json"
require "openssl"
require "jwt"

# https://github.com/jwt/ruby-jwt#json-web-key-jwk
JSON_WEB_KEY = JWT::JWK.new(
  OpenSSL::PKey::RSA.new(2048),
  { kid: 'my-key-id', use: 'sig', alg: 'RS512' }
)

def fetch_tunnel_url
  data = JSON.parse(Net::HTTP.get(URI("http://ngrok-agent:4040/api/tunnels")))
  data["tunnels"].select { |t| t["name"] == "command_line" }[0]["public_url"]
end

def public_keys
  JWT::JWK::Set.new(JSON_WEB_KEY).export
end

def generate_jwt
  # Some common claims seen used in the wild: ["aud","email","exp","iat","nbf","iss","name","sub","country"]
  claim_set = {
    "iss": fetch_tunnel_url,
    "aud": "openid_client_id", # needs to match value set in api gatewaway authorizer
    "exp": (Time.now + 30*60).to_i,
    "iat": Time.now.to_i
  }

  JWT.encode(claim_set, JSON_WEB_KEY.signing_key, JSON_WEB_KEY[:alg], kid: JSON_WEB_KEY[:kid])
end

# Fairly minimal openid configuration
def build_config(tunnel_url)
  {
    "issuer": tunnel_url,
    "authorization_endpoint": "#{tunnel_url}/authorize",
    "token_endpoint": "#{tunnel_url}/token",
    "userinfo_endpoint": "#{tunnel_url}/userinfo",
    "jwks_uri": "#{tunnel_url}/certs", # Used by the api gateway authorizer. Must match route defined in this app
    "response_types_supported": [
        "id_token",
        "code",
        "code id_token"
    ],
    "id_token_signing_alg_values_supported": [
        "RS512"
    ],
    "token_endpoint_auth_methods_supported": [
        "client_secret_post"
    ],
    "claims_supported": [
        "aud",
        "email",
        "exp",
        "iat",
        "nbf",
        "iss",
        "name",
        "sub",
        "country"
    ],
    "grant_types_supported": [
        "authorization_code"
    ]
  }
end
