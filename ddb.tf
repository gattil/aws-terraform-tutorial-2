resource "aws_dynamodb_table" "this" {
  name           = "${var.username}-ResultsDDBtable"
  read_capacity  = 3
  write_capacity = 3

  hash_key = "partitionKey"

  attribute {
    name = "partitionKey"
    type = "S"
  }

  tags = var.tags
}