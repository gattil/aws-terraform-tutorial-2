resource "aws_s3_bucket" "this" {
  bucket = "${var.username}-InputS3Bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = var.tags
}
