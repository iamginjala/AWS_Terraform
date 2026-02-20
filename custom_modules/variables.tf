variable "region" {
  default = "us-east-2"
  description = "default region for aws account"
  type = string
}

variable "bucket_name" {
  default = "static-website-hg231298"
  description = "bucket_name"
  type = string
}

variable "origin_id" {
  type = string
  default = "hr242714"
}