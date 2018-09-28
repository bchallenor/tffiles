data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      "arn:aws:lambda:*:*:function:${local.function_name}",
    ]
  }

  statement {
    actions = [
      "s3:GetBucketLocation",
    ]

    resources = [
      "${local.bucket_arn}",
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
      "ec2:ImportSnapshot",
      "ec2:DescribeImportSnapshotTasks",
      "ec2:CopySnapshot",
      "ec2:DescribeSnapshots",
    ]

    resources = ["*"]
  }

  # For safety, restrict deletion to snapshots without a parent volume.
  # This makes it less likely that we will accidentally delete a backup.
  statement {
    actions = [
      "ec2:DeleteSnapshot",
    ]

    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "ec2:ParentVolume"

      values = [
        "arn:aws:ec2:*:*:volume/vol-ffffffff",
      ]
    }
  }

  statement {
    actions = [
      "ec2:RegisterImage",
    ]

    resources = ["*"]
  }
}
