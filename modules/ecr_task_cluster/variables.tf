variable "name" {}

variable "image_names" {
  type = "list"
}

variable "cpu" {}
variable "memory" {}

variable "exec_role_arn" {}
variable "task_role_arn" {}
