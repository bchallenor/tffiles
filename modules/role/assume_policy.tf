resource "aws_iam_policy" "assume_policy" {
  name   = "assume-${aws_iam_role.role.name}"
  policy = "${data.aws_iam_policy_document.assume_policy.json}"
}

data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    resources = ["${aws_iam_role.role.arn}"]
  }
}
