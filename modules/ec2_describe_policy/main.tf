resource "aws_iam_policy" "policy" {
  name   = "ec2-describe"
  policy = "${data.aws_iam_policy_document.policy.json}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "ec2:Describe*",
    ]

    resources = [
      "*",
    ]
  }
}
