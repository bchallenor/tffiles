provider "aws" {
}

resource "aws_ecs_cluster" "default" {
  name = var.name
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/cluster/${var.name}"
  retention_in_days = 7
}

data "aws_arn" "log_group" {
  arn = aws_cloudwatch_log_group.default.arn
}

resource "aws_iam_policy" "run_policy" {
  name   = "ecr-${var.name}-run"
  policy = data.aws_iam_policy_document.run_policy.json
}

