module "aegis_secrets_volume" {
  source            = "./modules/volume"
  name              = "aegis-secrets"
  size              = 1
  availability_zone = "${var.stable_availability_zone}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "aegis_instance" {
  source            = "./modules/spot_instance"
  name              = "aegis"
  instance_type     = "t3.nano"
  spot_price        = "0.003"
  availability_zone = "${var.stable_availability_zone}"
  root_volume_size  = 2

  security_group_ids = [
    "${module.drawbridge_test.security_group_id}",
  ]

  persistent_volume_ids = [
    "${module.aegis_secrets_volume.id}",
  ]

  zone_id   = "${module.cloud_zone.id}"
  zone_name = "${module.cloud_zone.name}"

  providers = {
    "aws" = "aws.stable"
  }
}
