module "jenkins_secrets_volume" {
  source            = "./modules/volume"
  name              = "jenkins-secrets"
  size              = 1
  availability_zone = "${var.stable_availability_zone}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "jenkins_volume" {
  source            = "./modules/volume"
  name              = "jenkins"
  size              = 4
  availability_zone = "${var.stable_availability_zone}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "jenkins_instance" {
  source                = "./modules/spot_instance"
  name                  = "jenkins"
  instance_type         = "t3.medium"
  spot_price            = "0.018"
  availability_zone     = "${var.stable_availability_zone}"
  instance_profile_name = "${module.jenkins_profile.profile_name}"
  root_volume_size      = 20

  security_group_ids = [
    "${module.drawbridge_test.security_group_id}",
  ]

  persistent_volume_ids = [
    "${module.jenkins_secrets_volume.id}",
    "${module.jenkins_volume.id}",
  ]

  zone_id   = "${module.cloud_zone.id}"
  zone_name = "${module.cloud_zone.name}"

  providers = {
    "aws" = "aws.stable"
  }
}
