
resource "aws_route" "requester_route" {
    route_table_id = aws_vpc.vpc_requester.main_route_table_id
    destination_cidr_block = var.cidr_block_accepter
    vpc_peering_connection_id = aws_vpc_peering_connection.test_peer.id
  
}

resource "aws_route" "acceptor_route" {
    route_table_id = aws_vpc.vpc_accepter.main_route_table_id
    destination_cidr_block = var.cidr_block_requester
    vpc_peering_connection_id = aws_vpc_peering_connection.test_peer.id
    provider = aws.peer
  
}