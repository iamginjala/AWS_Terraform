resource "aws_vpc" "vpc_requester" {
    cidr_block = var.cidr_block_requester
      
}

resource "aws_subnet" "request_subnet" {
    vpc_id = aws_vpc.vpc_requester.id
    cidr_block = var.requester_subnet
    map_public_ip_on_launch = true
    availability_zone = data.aws_availability_zones.requester.names[0]
  
}
resource "aws_internet_gateway" "request_igw" {
  vpc_id = aws_vpc.vpc_requester.id

}