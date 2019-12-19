resource "aws_security_group" "github_client" {
  name   = "github-client"
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "github-client"
  }

  # egress: ssh, to Github
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.github_cidr_blocks
  }

  # egress: https, to Github
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.github_cidr_blocks
  }
}

data "http" "github_meta" {
  url = "https://api.github.com/meta"
}

locals {
  github_cidr_blocks = sort(jsondecode(data.http.github_meta.body).git)
}

