data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:StartInstances",
      "ec2:StopInstances",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/Drawbridge"
      values   = [var.name]
    }
  }

  # Does not support resource-level permissions, unfortunately
  statement {
    actions = [
      "ec2:ModifyInstanceAttribute",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name   = "drawbridge-${var.name}"
  policy = data.aws_iam_policy_document.policy.json
}

