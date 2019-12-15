provider "aws" {
}

resource "aws_vpc" "default" {
  cidr_block                       = "172.31.0.0/16"
  assign_generated_ipv6_cidr_block = true
  enable_dns_support               = true
  enable_dns_hostnames             = true

  tags = {
    Name = var.name
  }
}

