provider "aws" {}

resource "aws_security_group" "sg" {
  name        = "${var.name}"
  description = "Managed by Drawbridge"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name       = "${var.name}"
    Drawbridge = "${var.name}"
  }

  # Drawbridge controls ingress only
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
