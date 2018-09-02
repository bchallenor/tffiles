data "aws_iam_policy_document" "role_policy" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    resources = [
      "${var.bucket_arn}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${var.bucket_arn}/ami/*.img",
    ]
  }

  statement {
    actions = [
      "ec2:CopySnapshot",
      "ec2:DescribeSnapshots",
    ]

    resources = ["*"]
  }
}
