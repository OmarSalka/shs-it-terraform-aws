locals {
  second_lambda_zip_location = "outputs/codecommit-lambda-trigger.zip"
}

# Zip our python file
data "archive_file" "codecommit-lambda-trigger" {
  type        = "zip"
  source_file = "codecommit-lambda-trigger.py"
  output_path = local.second_lambda_zip_location
}

# AWS Lambda resource
resource "aws_lambda_function" "codecommit-lambda-trigger-function" {
  filename      = local.second_lambda_zip_location
  function_name = "codecommit-lambda-trigger"
  role          = aws_iam_role.codecommit-lambda-trigger-role.arn
  handler       = "codecommit-lambda-trigger.lambda_handler"

  # Will allow us to redeploy when we make changes to the source code
  source_code_hash = filebase64sha256(local.second_lambda_zip_location)

  runtime = "python3.7"

  timeout = 29

  environment {
    variables = {
      s3BucketName     = var.S3_BUCKET_NAME,
      codecommitRegion = var.AWS_REGION,
      repository       = var.CODECOMMIT_REPO,
      branch           = var.BRANCH
    }
  }
}
