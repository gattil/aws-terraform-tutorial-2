# --------------------------------------------------------------
# Provider
# --------------------------------------------------------------
provider "aws" {
  version = "2.50.0"
  region  = var.region

  assume_role {
    role_arn     = var.role_arn
  }
}
