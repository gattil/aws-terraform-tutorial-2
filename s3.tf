resource "aws_s3_bucket" "this" {
  bucket = "${var.username}-sentiment-analysis-input-s3-bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}
# ------------------------------------------------------------------------------
# Add notification to lambda
# ------------------------------------------------------------------------------

resource "aws_s3_bucket_notification" "sentiment" {
  bucket = aws_s3_bucket.this.id

  lambda_function {
    lambda_function_arn = module.sentiment.lambda_arn
    events              = [
      "s3:ObjectCreated:*"]
    filter_suffix       = ".json"
  }

  lambda_function {
    lambda_function_arn = module.transcribe.lambda_arn
    events              = [
      "s3:ObjectCreated:*"]
    filter_suffix       = ".mp3"
  }
}
