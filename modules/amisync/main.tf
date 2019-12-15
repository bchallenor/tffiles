data "aws_s3_bucket_object" "amisync" {
  bucket = var.bucket_name
  key    = "jar/amisync/amisync.jar"
}

resource "aws_lambda_function" "s3" {
  function_name     = "${var.name}-s3"
  role              = module.lambda_role.arn
  runtime           = "java8"
  handler           = "amisync.lambda.S3Handler::handleRequest"
  memory_size       = 256
  timeout           = 60
  s3_bucket         = data.aws_s3_bucket_object.amisync.bucket
  s3_key            = data.aws_s3_bucket_object.amisync.key
  s3_object_version = data.aws_s3_bucket_object.amisync.version_id

  environment {
    variables = {
      TASK_QUEUE_URL = aws_sqs_queue.task.id
    }
  }
}

resource "aws_lambda_function" "task" {
  function_name     = "${var.name}-task"
  role              = module.lambda_role.arn
  runtime           = "java8"
  handler           = "amisync.lambda.TaskHandler::handleRequest"
  memory_size       = 256
  timeout           = 60
  s3_bucket         = data.aws_s3_bucket_object.amisync.bucket
  s3_key            = data.aws_s3_bucket_object.amisync.key
  s3_object_version = data.aws_s3_bucket_object.amisync.version_id

  reserved_concurrent_executions = 1

  environment {
    variables = {
      TASK_QUEUE_URL     = aws_sqs_queue.task.id
      VMIMPORT_ROLE_NAME = module.vmimport_role.name
    }
  }
}

resource "aws_cloudwatch_log_group" "s3" {
  name              = "/aws/lambda/${aws_lambda_function.s3.function_name}"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "task" {
  name              = "/aws/lambda/${aws_lambda_function.task.function_name}"
  retention_in_days = 7
}

module "lambda_role" {
  source           = "../role"
  name             = var.name
  policy_json      = data.aws_iam_policy_document.lambda.json
  trusted_services = ["lambda.amazonaws.com"]
}

module "vmimport_role" {
  source           = "../role"
  name             = "vmimport-${var.name}"
  policy_json      = data.aws_iam_policy_document.vmimport.json
  trusted_services = ["vmie.amazonaws.com"]
}

