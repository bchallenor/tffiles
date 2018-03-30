provider "aws" {
  region = "us-east-1"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "iam:ListMFADevices",
    ]

    resources = [
      "arn:aws:iam::*:mfa/$${aws:username}",
      "arn:aws:iam::*:user/$${aws:username}",
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "self-management"
  policy = "${data.aws_iam_policy_document.policy.json}"
}
