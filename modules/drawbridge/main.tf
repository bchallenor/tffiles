provider "aws" {
  region = "${var.region}"
}

locals {
  name        = "drawbridge${var.profile == "default" ? "" : "-${var.profile}"}"
  description = "Drawbridge${var.profile == "default" ? "" : " with ${var.profile} profile"}"
}

resource "aws_security_group" "sg" {
  name        = "${local.name}"
  description = "Managed by ${local.description}"

  tags {
    Name       = "${local.name}"
    Drawbridge = "${var.profile}"
  }
}
