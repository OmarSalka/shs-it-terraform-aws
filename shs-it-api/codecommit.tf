resource "aws_codecommit_repository" "shs-it-front-end-repo" {
  repository_name = var.CODECOMMIT_REPO
  description     = "This is the repo that hosts the front end files"
  default_branch  = "master"
}

resource "aws_codecommit_trigger" "aws-codecommit-trigger" {
  repository_name = aws_codecommit_repository.shs-it-front-end-repo.repository_name

  trigger {
    name            = "lambda"
    events          = ["updateReference"]
    destination_arn = aws_lambda_function.codecommit-lambda-trigger-function.arn
  }
}

# Output: clone_url_http
output "clone_url_http" {
  value = aws_codecommit_repository.shs-it-front-end-repo.clone_url_http
}

