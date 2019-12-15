variable "name" {
}

variable "ami_owner" {
  default = "self"
}

variable "ami_name" {
  default = ""
}

locals {
  ami_name = var.ami_name != "" ? var.ami_name : "${var.name}-*"
}

variable "instance_type" {
}

variable "availability_zone" {
}

variable "subnet_id" {
}

variable "instance_profile_name" {
  default = ""
}

variable "root_volume_size" {
}

variable "security_group_ids" {
  type = list(string)
}

variable "zone_id" {
}

variable "zone_name" {
}

variable "persistent_volume_ids" {
  type    = list(string)
  default = []
}

variable "persistent_network_interface_ids" {
  type    = list(string)
  default = []
}

