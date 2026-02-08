resource "aws_vpc" "vpc_accepter" {
    cidr_block = var.cidr_block_accepter
    provider = aws.peer
}