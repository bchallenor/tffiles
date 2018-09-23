output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public.id}"
}

output "private_subnet_id" {
  value = "${aws_subnet.private.id}"
}

output "public_vpn_server_security_group_id" {
  value = "${aws_security_group.public_vpn_server.id}"
}

output "private_vpn_server_network_interface_id" {
  value = "${aws_network_interface.private_vpn_server.id}"
}

output "vpn_target_security_group_id" {
  value = "${aws_security_group.vpn_target.id}"
}