provider "aws" {
  region = "us-east-1"
}

locals {
  name = "drawbridge${var.profile == "default" ? "" : "-${var.profile}"}"
}
