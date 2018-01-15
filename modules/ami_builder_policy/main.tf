provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "ec2:DescribeVolumes",
      "ec2:CreateVolume",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:DeleteVolume",
      "ec2:DescribeSnapshots",
      "ec2:CreateSnapshot",
      "ec2:DescribeImages",
      "ec2:RegisterImage",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "ami-builder"
  policy = "${data.aws_iam_policy_document.policy.json}"
}
