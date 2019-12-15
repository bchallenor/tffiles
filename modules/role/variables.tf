variable "name" {
}

variable "trusted_services" {
  default = []
}

variable "policy_json" {
  default = ""
}

variable "policy_arns" {
  default = []
}

variable "create_instance_profile" {
  default = "false"
}

