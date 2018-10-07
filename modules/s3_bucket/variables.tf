variable "name" {}

variable "transition_days" {
  default = 30
}

variable "noncurrent_version_transition_days" {
  default = 30
}

variable "noncurrent_version_expiration_days" {
  default = 90
}
