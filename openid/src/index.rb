# frozen_string_literal: true

# Note that any code changes require restarting the container (don't have to rebuild). This is because spring isn't
# included like in Rails, but probably not needed for the scope of this local app.

require "sinatra"

require_relative "./helpers"

# Use error handling in all environments
disable :show_exceptions

set :default_content_type, "application/json"

# Path expected by OpenID official spec. Used by api gateway authorizer to verify the JWT
get "/.well-known/openid-configuration" do
  build_config(fetch_tunnel_url).to_json
end

# Path specified in openid-configuration. Publishes the public keys corresponding to the private keys used to sign JWTs
# Used by api gateway authorizer to verify the authenticity of the JWT signature
get "/certs" do
  public_keys.to_json
end

# Only used locally for convenience. Not specific to openid app, can be extracted if it helps
get "/tunnel_url" do
  fetch_tunnel_url
end

# Only used locally for convenience
get "/jwt" do
  generate_jwt
end

error 404 do
  { error: "Route does not exist" }
end

error do |error|
  status 500
  message = "#{error.class} #{error.message} #{error.backtrace}"
  logger.error message

  { error: message }
end
