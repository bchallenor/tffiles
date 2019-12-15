provider "aws" {
}

resource "aws_codecommit_repository" "repo" {
  repository_name = var.name
}

