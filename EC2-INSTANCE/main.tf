
resource "aws_s3_bucket" "test_bucket" {
  count = length(var.bucket_list)
  bucket = var.bucket_list[count.index]
}

resource "aws_s3_bucket" "test_bucket2" {
  for_each = var.bucket_set
  bucket = each.valueff
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
    filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] 

}

resource "aws_instance" "test_ec2" {
  count = var.instance_count
  ami =  data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  monitoring = var.monitoring_enabled
  associate_public_ip_address = var.associate_public_ip
  
}

resource "aws_vpc" "test_vpc" {
  cidr_block = var.cidr_blocks[0]
}
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = var.cidr_blocks[1]
  map_public_ip_on_launch = var.associate_public_ip

  
}
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = var.cidr_blocks[2]
}