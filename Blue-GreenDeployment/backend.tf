terraform {
  backend "s3" {
    bucket = "deom-for-tfstate-files-0128"
    encrypt = true
    key = "dev/blue-greendeployment/terraform.tfstate"
    region = "us-east-2"
    use_lockfile = true

  }
}