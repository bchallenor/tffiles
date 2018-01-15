resource "aws_iam_policy" "write_policy" {
  name   = "s3-${aws_s3_bucket.bucket.bucket}-write"
  policy = "${data.aws_iam_policy_document.write_policy.json}"
}

data "aws_iam_policy_document" "write_policy" {
  statement {
    actions = [
      "s3:ListObjects",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
    ]
  }
}
