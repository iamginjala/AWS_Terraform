output "vpc_accepter_id" {
    value = aws_vpc.vpc_accepter.id
    description = "aws vpc accepter id"
}

output "vpc_requester_id" {
  value = aws_vpc.vpc_requester.id
  description = "aws vpc requester id"

}

output "peering_connection_id" {
  value = aws_vpc_peering_connection.test_peer.id
  description = "shows the vpc peering connection id"
}

output "peering_connection_status" {
    value = aws_vpc_peering_connection.test_peer.accept_status
    description = "shows the status vpc peering connection"
  
}