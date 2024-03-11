resource "aws_apigatewayv2_api" "this" {
  name        = "${var.service}-local-${var.environment}"
  description = "Endpoint for requests to local app"

  protocol_type = "HTTP"

  tags = local.tags
}

resource "aws_apigatewayv2_stage" "this" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "$default"

  auto_deploy = true
}

resource "aws_apigatewayv2_authorizer" "this" {
  api_id = aws_apigatewayv2_api.this.id
  name   = "local-jwt"

  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    # Will automatically append the path /.well-known/openid-configuration
    issuer   = var.local_proxy_base_url
    audience = ["openid_client_id"]
  }
}

locals {
  # TODO: Replace with input variable
  local_app_endpoint_path = "/PLACEHOLDER"
}

# TODO: Provide endpoint config as input variable
resource "aws_apigatewayv2_integration" "this" {
  api_id = aws_apigatewayv2_api.this.id

  integration_type   = "HTTP_PROXY"
  integration_method = "POST"
  integration_uri    = "${var.local_proxy_base_url}${local.local_app_endpoint_path}"

  # Example of how to pass jwt payload data to the app
  # request_parameters = {
  #   "append:header.X-Auth-Token-Issuer" = "$context.authorizer.claims.iss"
  # }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_route" "this" {
  api_id    = aws_apigatewayv2_api.this.id
  route_key = "POST ${local.local_app_endpoint_path}"

  target = "integrations/${aws_apigatewayv2_integration.this.id}"

  authorization_type = aws_apigatewayv2_authorizer.this.authorizer_type
  authorizer_id      = aws_apigatewayv2_authorizer.this.id
}

# This is for local convenience so that you can more easily make requests to your gateway
output "endpoint_api_gateway_base_url" {
  value = aws_apigatewayv2_api.this.api_endpoint
}
output "endpoint_api_gateway_arn" {
  value = aws_apigatewayv2_api.this.arn
}
