variable "region" {
  type = string
  default = "us-east-2"
  
}

variable "project_name" {
    type = string
    default = "Project ALPHA Resource"
  
}
variable "default_tags" {
    type = map(string)
    default = {
      company = "HashiCorp"
      managed_by = "Terraform"
    }
}
variable "environment_tags" {
  type = map(string)
  default = {
    environment = "dev"
    team = "devops"
  }
}
variable "bucket_name" {
  type = string
  description = "s3 bucket "
  default  = "ProjectAlphaStorageBucket with CAPS and spaces!!!"
}

variable "allowed_ports" {
    type = string
    description = "Comma-separated list of allowed ports"
    default     = "80,443,8080,3306"
  
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
}

variable "instance_sizes" {
  type = map(string)
  default = {
    dev     = "t2.micro"
    staging = "t3.small"
    prod    = "t3.large"
  }
}

variable "instance_type" {
    type = string
    description = "choose instance type"
    default = "t2.micro"
    
    validation {
      condition = length(var.instance_type) >= 2 && length(var.instance_type) <= 10
      error_message = "instance type must be between 2 and 10 characters long." 
    }

    validation {
      condition = can(regex("^t[2-3]\\.", var.instance_type))
      error_message = "Instance type must start with 't2.' or 't3.'."
    }

}
variable "backup_name" {
    type = string
    description = "backup name for instance"
    default = "daily_backup"

    validation {
      condition = endswith(var.backup_name,"_backup")
      error_message = "must end with '_backup'"
    }
  
}

variable "credential" {
  type        = string
  description = "Sensitive credential"
  default     = "xyz123"
  sensitive   = true
}