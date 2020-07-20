# ------------------------------------------------------------------------------
# Transcribe function
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "transcribe_policy" {

  statement {
    sid       = "S3CrudPolicy"
    effect    = "Allow"
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"]
    actions   = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:DeleteObject"
    ]
  }
  statement {
    sid       = "transcribeMP3"
    effect    = "Allow"
    resources = ["*"]
    actions   = [
      "transcribe:StartTranscriptionJob"
    ]
  }
  statement {
    sid       = "getCloudwatchMetrics"
    effect    = "Allow"
    resources = ["*"]
    actions   = [
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics"
    ]
  }
}

module "transcribe" {
  source = "./modules/lambda"

  prefix = var.username
  tags   = var.tags

  lambda_name        = "transcribe"
  lambda_folder_path = "${path.module}/lambdas/transcribeFunction"
  lambda_policy      = data.aws_iam_policy_document.transcribe_policy.json

  filter_suffix = ".mp3"
  s3_bucket_id = aws_s3_bucket.this.id
  s3_bucket_arn = aws_s3_bucket.this.arn
}

# ------------------------------------------------------------------------------
# Sentiment detection function
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "sentiment_policy" {

  statement {
    sid       = "DynamoDBCrudPolicy"
    effect    = "Allow"
    resources = [
      aws_dynamodb_table.this.arn,
      "${aws_dynamodb_table.this.arn}/index/*"]
    actions   = [
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:PutItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:BatchGetItem",
      "dynamodb:DescribeTable",
      "dynamodb:ConditionCheckItem"
    ]
  }
  statement {
    sid       = "S3CrudPolicy"
    effect    = "Allow"
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"]
    actions   = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:DeleteObject"
    ]
  }
  statement {
    sid       = "comprehendDetectSentimentPolicy"
    effect    = "Allow"
    resources = ["*"]
    actions   = [
      "comprehend:DetectSentiment"
    ]
  }

}
module "sentiment" {
  source = "./modules/lambda"

  prefix = var.username
  tags   = var.tags

  lambda_name        = "sentiment"
  lambda_folder_path = "${path.module}/lambdas/sentimentFunction"
  lambda_policy      = data.aws_iam_policy_document.sentiment_policy.json

  lambda_environment_variables = {
    ddbTable = aws_dynamodb_table.this.name
  }

  filter_suffix = ".json"
  s3_bucket_id = aws_s3_bucket.this.id
  s3_bucket_arn = aws_s3_bucket.this.arn
}