# --------------------------------------------------------------
# Variables
# --------------------------------------------------------------
variable "region" {
  type    = string
  default = "eu-central-1"
}
variable "role_arn" {
  type = string
}
variable "username" {
  type = string
}
variable "tags"{
  type = map(string)
}