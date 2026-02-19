variable "bucket_name" {
  type = string
  description = "bucket name for the website"
  
}

variable "origin_id" {
  type = string
  description = "origin id for AWS cloud front"
}
variable "default_root_object" {
  type = string
  description = "root object for cloud front"
  default = "index.html"
}
variable "website_files" {
  type = list(string)
  default = [ "index.html","error.html" ]
  description = "website files for s3"
}
