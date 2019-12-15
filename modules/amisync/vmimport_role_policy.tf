data "aws_iam_policy_document" "vmimport" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]

    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    resources = [
      local.bucket_arn,
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${local.bucket_arn}/ami/*.img",
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

