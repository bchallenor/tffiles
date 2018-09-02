resource "aws_lambda_function" "fn" {
  function_name    = "${var.name}"
  role             = "${module.lambda_role.arn}"
  runtime          = "python3.6"
  handler          = "ami_importer.aws_lambda_handler"
  timeout          = 300
  filename         = "${data.archive_file.fn.output_path}"
  source_code_hash = "${data.archive_file.fn.output_base64sha256}"

  environment {
    variables = {
      VMIMPORT_ROLE_NAME = "${module.vmimport_role.name}"
    }
  }
}

data "archive_file" "fn" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/build.zip"
}

module "lambda_role" {
  source        = "./modules/lambda_role"
  name          = "${var.name}"
  function_name = "${var.name}"
  bucket_arn    = "${data.aws_s3_bucket.bucket.arn}"
}

module "vmimport_role" {
  source     = "./modules/vmimport_role"
  name       = "vmimport-${var.name}"
  bucket_arn = "${data.aws_s3_bucket.bucket.arn}"
}
