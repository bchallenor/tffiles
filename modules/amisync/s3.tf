data "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

locals {
  bucket_arn = data.aws_s3_bucket.bucket.arn
}

resource "aws_lambda_permission" "bucket" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.bucket.arn
}

resource "aws_s3_bucket_notification" "bucket" {
  bucket = data.aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3.arn

    events = [
      "s3:ObjectCreated:*",
      "s3:ObjectRemoved:*",
    ]

    filter_prefix = "ami/"
    filter_suffix = ".img"
  }

  depends_on = [aws_lambda_permission.bucket]
}

