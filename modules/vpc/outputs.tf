output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public.id}"
}

output "private_subnet_id" {
  value = "${aws_subnet.private.id}"
}

output "private_vpn_server_network_interface_id" {
  value = "${aws_network_interface.private_vpn_server.id}"
}
