# API-GW REST-API
resource "aws_api_gateway_rest_api" "shs-it-api-gateway-rest-api" {
  name        = "shs-it-api-gateway"
  description = "Connects front end to lambda function"
}

# API_GW resource
resource "aws_api_gateway_resource" "shs-it-api-gateway-resource" {
  rest_api_id = aws_api_gateway_rest_api.shs-it-api-gateway-rest-api.id
  parent_id   = aws_api_gateway_rest_api.shs-it-api-gateway-rest-api.root_resource_id
  path_part   = "shs-it-api"
}

# API_GW method
resource "aws_api_gateway_method" "shs-it-api-gateway-method" {
  rest_api_id   = aws_api_gateway_rest_api.shs-it-api-gateway-rest-api.id
  resource_id   = aws_api_gateway_resource.shs-it-api-gateway-resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Lambda Integration
resource "aws_api_gateway_integration" "shs-it-api-gateway-integration" {
  rest_api_id             = aws_api_gateway_rest_api.shs-it-api-gateway-rest-api.id
  resource_id             = aws_api_gateway_resource.shs-it-api-gateway-resource.id
  http_method             = aws_api_gateway_method.shs-it-api-gateway-method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.shs-it-lambda.invoke_arn
}

# API-GW Deployment
resource "aws_api_gateway_deployment" "shs-it-api-gateway-deployment" {
  depends_on = ["aws_api_gateway_integration.shs-it-api-gateway-integration"]

  rest_api_id = aws_api_gateway_rest_api.shs-it-api-gateway-rest-api.id
  stage_name  = "prod"

}

# Output: API URL
output "api-gateway-invoke-url" {
  value = aws_api_gateway_deployment.shs-it-api-gateway-deployment.invoke_url
}
