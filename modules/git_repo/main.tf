provider "aws" {
  region = "${var.region}"
}

resource "aws_codecommit_repository" "repo" {
  repository_name = "${var.name}"
}
