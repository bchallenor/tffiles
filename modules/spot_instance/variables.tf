variable "name" {}
variable "instance_type" {}
variable "spot_price" {}
variable "availability_zone" {}

variable "instance_profile_name" {
  default = ""
}

variable "root_volume_size" {}

variable "security_group_ids" {
  type = "list"
}

variable "zone_id" {}
variable "zone_name" {}

variable "persistent_volume_ids" {
  type    = "list"
  default = []
}

variable "persistent_network_interface_ids" {
  type    = "list"
  default = []
}
