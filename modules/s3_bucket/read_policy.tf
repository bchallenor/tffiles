resource "aws_iam_policy" "read_policy" {
  name   = "s3-${aws_s3_bucket.bucket.bucket}-read"
  policy = "${data.aws_iam_policy_document.read_policy.json}"
}

data "aws_iam_policy_document" "read_policy" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}
