data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "all" {}

data "aws_subnet" "default" {
  vpc_id            = "${data.aws_vpc.default.id}"
  availability_zone = "${element(data.aws_availability_zones.all.names, count.index)}"
  count             = "${length(data.aws_availability_zones.all.names)}"
}

resource "aws_security_group" "sg" {
  name = "batch-${var.name}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
