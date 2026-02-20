module "static" {
  source = "./static-website"
  bucket_name = var.bucket_name
  origin_id = var.origin_id
}

output "url" {
  value = module.static.url
  description = "cloud front url"
}

output "bucket_name" {
  value = module.static.bucket_name
  description = "s3 bucket name"
}
