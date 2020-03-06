locals {
  lambda_zip_location = "outputs/shs-it-api.zip"
}

# Zip our python file
data "archive_file" "shs-it-api" {
  type        = "zip"
  source_file = "shs-it-api.py"
  output_path = local.lambda_zip_location
}

# AWS Lambda resource
resource "aws_lambda_function" "shs-it-lambda" {
  filename      = local.lambda_zip_location
  function_name = "shs-it-api"
  role          = aws_iam_role.shs-it-api-lambda-role.arn
  handler       = "shs-it-api.lambda_handler"

  # Will allow us to redeploy when we make changes to the source code
  source_code_hash = filebase64sha256(local.lambda_zip_location)

  runtime = "python3.7"

  timeout = 29
}

resource "aws_lambda_permission" "api-gateway-lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shs-it-lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.AWS_REGION}:${var.ACCOUNT_ID}:${aws_api_gateway_rest_api.shs-it-api-gateway-rest-api.id}/*/${aws_api_gateway_method.shs-it-api-gateway-method.http_method}/${aws_api_gateway_resource.shs-it-api-gateway-resource.path_part}"
}
