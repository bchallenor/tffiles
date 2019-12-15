provider "aws" {
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.name
  acl    = "private"

  versioning {
    enabled = false
  }

  lifecycle_rule {
    id      = "lifecycle"
    prefix  = ""
    enabled = true

    abort_incomplete_multipart_upload_days = 1

    expiration {
      days = var.expiration_days
    }
  }
}

