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

output "primary_instance_private_ip" {
  description = "Private IP of the Primary EC2 Instance"
  value       = aws_instance.requester_ec2.private_ip
}

output "secondary_instance_private_ip" {
  description = "Private IP of the Secondary EC2 Instance"
  value       = aws_instance.accepter_ec2.private_ip
}
output "third_instance_private_ip" {
  description = "Public IP of the third EC2 Instance"
  value       = aws_instance.trans_ec2.private_ip
}

output "primary_instance_public_ip" {
  description = "Public IP of the Primary EC2 Instance"
  value       = aws_instance.requester_ec2.public_ip
}

output "secondary_instance_public_ip" {
  description = "Public IP of the Secondary EC2 Instance"
  value       = aws_instance.accepter_ec2.public_ip
}

output "third_instance_public_ip" {
  description = "Public IP of the third EC2 Instance"
  value       = aws_instance.trans_ec2.public_ip
}
