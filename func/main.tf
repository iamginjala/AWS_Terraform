# locals {
#   formatted_project_name = replace(lower(var.project_name), " ", "-")
#   replace_bucket_name = replace(trim(lower(var.bucket_name)," !"), " ", "")
#   port_list = split(",",var.allowed_ports)
#   ports = [ for port in local.port_list :{
#     name = "port - ${port}"
#     port = tonumber(port)
#     description = "Allow traffic on port ${port}"
#   }]
#   formatted_ports = join("-", [for port in local.port_list : "port-${port}"])
#   instance_sizes = lookup(var.instance_sizes,var.environment,"t2.micro")
# }



# # output "test-split" {
# #     value = local.ports
  
# # }
# # output "test_bucket_name" { 
# #     value = local.replace_bucket_name
  
# # }

# resource "aws_s3_bucket" "test-bucket" {
#     bucket = local.replace_bucket_name
#     tags = merge(var.default_tags, var.environment_tags)
# }

# resource "aws_vpc" "sg_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     name = "${local.formatted_project_name}-vpc"
#     assignment = 4
#   }
  
# }

# resource "aws_security_group" "test_sg" {
#     name = "${local.formatted_project_name}-sg"
#     vpc_id = aws_vpc.sg_vpc.id

#     dynamic "ingress" {
#         for_each = local.ports
#         content {
#             from_port = ingress.value.port
#             to_port = ingress.value.port
#             protocol = "tcp"
#             cidr_blocks = ["0.0.0.0/0"]
#         }
#     }
#     egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
  
# }
# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#   }
# }
# resource "aws_instance" "app_server" {
#     ami = data.aws_ami.amazon_linux.id
#     instance_type = local.instance_sizes
#     security_groups = [aws_security_group.test_sg.name]
#     tags = {
#         name = "app-server-${var.environment}"
#         environment = var.environment
#         instance_type = local.instance_sizes
#     }

# }
# locals {
#     backup_config ={
#         name = var.backup_name
#         credential = var.credential
#         enabled = true
#     }
# }

# output "backup_sensitive" {
#     value = local.backup_config
  
# }

# data "aws_ami" "valaidated_ami" {
#     most_recent = true
#     owners = ["amazon"]

#     filter {
#         name = "name"
#         values = ["amzn2-ami-hvm-*-x86_64-gp2"]
#     }
# }
# resource "aws_instance" "validated_instance" {
#     ami = data.aws_ami.valaidated_ami.id
#     instance_type = var.instance_type
# }

locals {
  # Check if files exist
  config_files = [
    "./main.tf",
    "./variables.tf"
  ]
  
  file_status = { for file_path in local.config_files :
    file_path => fileexists(file_path)
  }
  
  # Extract directory names
  config_dirs = { for file_path in local.config_files :
    file_path => dirname(file_path)
  }
}

output "file_existence_status" {
  value = local.file_status
}
output "file_path" {
  value = local.config_dirs
}