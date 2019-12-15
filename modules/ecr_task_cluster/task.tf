resource "aws_ecs_task_definition" "task" {
  family = "${var.name}-${replace(element(var.image_names, count.index), "/.*//", "")}"
  count  = length(var.image_names)

  requires_compatibilities = ["FARGATE"]

  #TODO(v0.12): jsonencode a local instead
  container_definitions = <<EOF
[{
  "name": ${jsonencode(
  "${var.name}-${replace(element(var.image_names, count.index), "/.*//", "")}",
)},
  "image": ${jsonencode(element(var.image_names, count.index))},
  "logConfiguration": {
    "logDriver": "awslogs",
    "options": {
      "awslogs-region": ${jsonencode(data.aws_arn.log_group.region)},
      "awslogs-group": ${jsonencode(aws_cloudwatch_log_group.default.name)},
      "awslogs-stream-prefix": "task"
    }
  },
  "disableNetworking": false,
  "essential": true
}]
EOF


cpu          = var.cpu
memory       = var.memory
network_mode = "awsvpc"

execution_role_arn = var.exec_role_arn
task_role_arn      = var.task_role_arn
}

