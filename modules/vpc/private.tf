resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${var.availability_zone}"

  cidr_block      = "${cidrsubnet(aws_vpc.default.cidr_block, 8, 2)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.default.ipv6_cidr_block, 8, 2)}"

  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = false

  tags {
    Name = "${var.name}-private"
  }
}

resource "aws_egress_only_internet_gateway" "private" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table_association" "private" {
  subnet_id      = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.name}-private"
  }
}

resource "aws_route" "private_ipv6_gateway" {
  route_table_id              = "${aws_route_table.private.id}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.private.id}"
}
