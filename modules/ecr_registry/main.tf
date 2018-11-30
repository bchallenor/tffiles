provider "aws" {}

resource "aws_ecr_repository" "repo" {
  name  = "${var.name}/${element(var.repos, count.index)}"
  count = "${length(var.repos)}"
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = "${aws_ecr_repository.repo.*.name[count.index]}"
  policy     = "${file("${path.module}/lifecycle_policy.json")}"
  count      = "${length(var.repos)}"
}

resource "aws_iam_policy" "pull_policy" {
  name   = "ecr-${var.name}-pull"
  policy = "${data.aws_iam_policy_document.pull_policy.json}"
}

resource "aws_iam_policy" "push_policy" {
  name   = "ecr-${var.name}-push"
  policy = "${data.aws_iam_policy_document.push_policy.json}"
}

module "exec_role" {
  source           = "../role"
  name             = "ecr-${var.name}-exec"
  policy_json      = "${data.aws_iam_policy_document.exec_role_policy.json}"
  trusted_services = ["ecs-tasks.amazonaws.com"]
}
