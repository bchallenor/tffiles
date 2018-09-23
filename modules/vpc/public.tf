resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.default.id}"
  availability_zone = "${var.availability_zone}"

  cidr_block      = "${cidrsubnet(aws_vpc.default.cidr_block, 8, 1)}"
  ipv6_cidr_block = "${cidrsubnet(aws_vpc.default.ipv6_cidr_block, 8, 1)}"

  assign_ipv6_address_on_creation = true
  map_public_ip_on_launch         = true

  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_route" "public_ipv6_gateway" {
  route_table_id              = "${aws_route_table.public.id}"
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = "${aws_internet_gateway.public.id}"
}

resource "aws_route" "public_ipv4_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.public.id}"
}
