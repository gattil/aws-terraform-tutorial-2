variable "prefix"{
  default = ""
}

variable "tags"{
  default = {}
}

# ---------------------------------------------------------------

variable "lambda_name"{
  default = "lambda"
}
variable "lambda_folder_path"{
  default = ""
}
variable "lambda_handler"{
  default = "app.handler"
}
variable "lambda_timeout"{
  default = "10"
}
variable "lambda_runtime"{
  default  = "nodejs12.x"
}
variable "lambda_environment_variables"{
  default  = {}
}
variable "lambda_policy"{
  default = {}
}

# ---------------------------------------------------------------
variable "filter_suffix" {
  default = ""
}
variable "s3_bucket_id"{
  default = ""
}
variable "s3_bucket_arn"{
  default = ""
}