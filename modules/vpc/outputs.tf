output "vpc_id" {
  value = aws_vpc.default.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

output "public_nat_server_security_group_id" {
  value = aws_security_group.public_nat_server.id
}

output "private_nat_server_network_interface_id" {
  value = aws_network_interface.private_nat_server.id
}

output "public_vpn_server_security_group_id" {
  value = aws_security_group.public_vpn_server.id
}

output "private_vpn_server_network_interface_id" {
  value = aws_network_interface.private_vpn_server.id
}

output "vpn_target_security_group_id" {
  value = aws_security_group.vpn_target.id
}

output "http_client_security_group_id" {
  value = aws_security_group.http_client.id
}

output "https_client_security_group_id" {
  value = aws_security_group.https_client.id
}

output "github_client_security_group_id" {
  value = aws_security_group.github_client.id
}

