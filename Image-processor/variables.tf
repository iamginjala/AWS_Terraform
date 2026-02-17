variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "image-processor"
}
variable "tags" {
  description = "default tags for the project"
  type = map(string)
  default = {
    Project = "ImageProcessingApp"
    Environment = "dev"
  }
}