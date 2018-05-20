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

  statement {
    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "arn:aws:ec2:*::snapshot/*",
      "arn:aws:ec2:*::image/*",
    ]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "ami-builder"
  policy = "${data.aws_iam_policy_document.policy.json}"
}
