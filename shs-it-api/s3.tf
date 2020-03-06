# S3 bucket with static hosting
resource "aws_s3_bucket" "shs-it-website" {
  bucket = var.S3_BUCKET_NAME
  acl    = "public-read"
  policy = file("iam/s3-bucket-policy.json")

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

# Website Endpoint
output "website_endpoint" {
  value = aws_s3_bucket.shs-it-website.website_endpoint
}
