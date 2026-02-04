data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-*-x86_64"]
  }  
}

resource "aws_instance" "example" {
    ami = data.aws_ami.amazon_linux.id
    count = var.instance_count
    instance_type = var.environment == "dev" ? "t2.micro": "t3.micro"
      
}
resource "aws_security_group" "example" {
  name   = "sg"

  dynamic "ingress" {
    for_each = var.ingress_rule
    content {
      from_port = ingress.value.from_port
      to_port = ingress.value.to_port
      protocol = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description 
    }
  }
  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
}

locals {
  ami_instance_ids = aws_instance.example[*].id
}

output "test" {
    value =  local.ami_instance_ids
  
}