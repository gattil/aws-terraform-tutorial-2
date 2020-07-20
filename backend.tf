# --------------------------------------------------------------
# Backend for state storage
# --------------------------------------------------------------
terraform {
  backend "s3" {
    bucket         = "<state-file-s3-bucket-id>"
    key            = "<your-name>-sentiment-analysis.tfstate"
    dynamodb_table = "<dynamo_db_table>"
    region         = "eu-central-1"
    role_arn       = "arn:aws:iam::<account-id>:role/<role-name>"
  }
}
