provider "aws" {}

module "bucket" {
  source = "../s3_bucket"
  name   = "${var.bucket_name}"

  providers = {
    "aws" = "aws"
  }
}

data "aws_caller_identity" "self" {}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "${module.bucket.arn}",
    ]
  }

  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${module.bucket.arn}/AWSLogs/${data.aws_caller_identity.self.account_id}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = "${module.bucket.id}"
  policy = "${data.aws_iam_policy_document.bucket_policy.json}"
}

resource "aws_cloudtrail" "trail" {
  name                       = "trail"
  s3_bucket_name             = "${module.bucket.id}"
  is_multi_region_trail      = true
  enable_log_file_validation = true
}
