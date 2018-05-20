provider "aws" {}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.name}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "lifecycle"
    prefix  = ""
    enabled = true

    abort_incomplete_multipart_upload_days = 1

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      expired_object_delete_marker = true
    }

    noncurrent_version_expiration {
      days = 90
    }
  }
}
