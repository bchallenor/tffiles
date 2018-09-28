resource "aws_iam_user" "user" {
  name          = "${var.user}"
  force_destroy = "true"
}

resource "aws_iam_user_policy" "assume_role" {
  name   = "assume-role"
  user   = "${aws_iam_user.user.name}"
  policy = "${data.aws_iam_policy_document.assume_role.json}"
  count  = "${length(var.role_arns) > 0 ? 1 : 0}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["${var.role_arns}"]
  }

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

resource "aws_iam_user_policy_attachment" "user" {
  user       = "${aws_iam_user.user.name}"
  policy_arn = "${element(var.policy_arns, count.index)}"
  count      = "${length(var.policy_arns)}"
}
