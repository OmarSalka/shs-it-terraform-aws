# Lambda assume policy
resource "aws_iam_role_policy" "lambda_codecommit_trigger_policy" {
  name = "lambda_codecommit_trigger_policy"
  role = aws_iam_role.codecommit-lambda-trigger-role.id

  policy = file("iam/codecommit-lambda-trigger-policy.json")
}

# Lambda policy
resource "aws_iam_role" "codecommit-lambda-trigger-role" {
  name = "codecommit-lambda-trigger-role"

  assume_role_policy = file("iam/lambda-assume-policy.json")
}
