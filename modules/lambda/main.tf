#AWS_REGION
#ddbTable

data "archive_file" "this" {
  type        = "zip"
  source_file = var.lambda_folder_path
  output_path = "${path.module}/lambdas/unicorn-management-service.zip"
}

resource "aws_lambda_function" "this" {
  filename      = data.archive_file.this.output_path
  function_name = "${var.prefix}-${var.lambda_name}"
  role          = aws_iam_role.this.arn
  handler       = var.lambda_handler
  timeout       = var.lambda_timeout

  #  The filebase64sha256() function is available in Terraform 0.11.12 and later
  #  For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #  source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.this.output_base64sha256

  runtime = var.lambda_runtime

  environment {
    variables = var.lambda_environment_variables
  }

  tags = var.tags
}

resource "aws_iam_role" "this" {
  name = "${var.prefix}-${var.lambda_name}-iam-role"

  assume_role_policy    = <<EOF
 {
   "Version": "2012-10-17",
   "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "lambda.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
     }
   ]
 }
 EOF
  force_detach_policies = true
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "standard-lambda-policy-attachment" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "extra_policy" {
  count = length(var.lambda_policy) > 0 ? 1 : 0
  policy = var.lambda_policy
}

resource "aws_iam_role_policy_attachment" "extra-lambda-policy-attachment" {
  count = length(var.lambda_policy) > 0 ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.extra_policy.arn

}

resource "aws_s3_bucket_notification" "this" {
  bucket = var.s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = [
      "s3:ObjectCreated:*"]
    filter_suffix       = var.filter_suffix
    //".txt"
  }
}
