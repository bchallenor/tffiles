resource "aws_sqs_queue" "task" {
  name = "${var.name}-task"

  message_retention_seconds  = "${60 * 60 * 24 * 1}"
  visibility_timeout_seconds = "${60 * 5}"

  redrive_policy = <<EOF
{
  "deadLetterTargetArn": "${aws_sqs_queue.task_dead.arn}",
  "maxReceiveCount": 2
}
EOF
}

resource "aws_sqs_queue" "task_dead" {
  name = "${var.name}-task-dead"

  message_retention_seconds = "${60 * 60 * 24 * 14}"
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = "${aws_sqs_queue.task.arn}"
  batch_size       = 1
  function_name    = "${aws_lambda_function.task.arn}"
}
