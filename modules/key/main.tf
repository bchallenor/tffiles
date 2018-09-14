provider "aws" {}

resource "aws_kms_key" "key" {
  description             = "${var.name}"
  deletion_window_in_days = 7
  enable_key_rotation     = false
}

resource "aws_kms_alias" "key" {
  name          = "alias/${var.name}"
  target_key_id = "${aws_kms_key.key.key_id}"
}
