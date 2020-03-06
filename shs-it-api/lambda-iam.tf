# Lambda assume policy
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.shs-it-api-lambda-role.id

  policy = file("iam/lambda-policy.json")
}

# Lambda policy
resource "aws_iam_role" "shs-it-api-lambda-role" {
  name = "shs-it-api-lambda-role"

  assume_role_policy = file("iam/lambda-assume-policy.json")
}
