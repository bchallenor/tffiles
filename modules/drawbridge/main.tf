provider "aws" {
}

resource "aws_security_group" "sg" {
  name        = "drawbridge-${var.name}"
  description = "Managed by Drawbridge"
  vpc_id      = var.vpc_id

  tags = {
    Name       = "drawbridge-${var.name}"
    Drawbridge = var.name
  }
}

