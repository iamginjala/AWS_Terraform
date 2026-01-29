locals {
  environment = var.my_tag
  project = "terraform-practice"

  common_tags = {
    Environment = local.environment
    Project = local.project
    ManagedBy = "Terraform"
  }
}