terraform {
  backend "s3" {
    bucket = "deom-for-tfstate-files-0128"
    encrypt = true
    key = "dev/provisioners/terraform.tfstate"
    region = "us-east-2"
    use_lockfile = true
  }
}