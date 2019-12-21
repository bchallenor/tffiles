module "helios_secrets_volume" {
  source            = "./modules/volume"
  name              = "helios-secrets"
  size              = 1
  availability_zone = var.stable_availability_zone

  providers = {
    aws = aws.stable
  }
}

module "helios_home_volume" {
  source            = "./modules/volume"
  name              = "helios-home"
  size              = 4
  availability_zone = var.stable_availability_zone

  providers = {
    aws = aws.stable
  }
}

module "helios_instance" {
  source            = "./modules/instance"
  name              = "helios"
  instance_type     = "t3.small"
  availability_zone = var.stable_availability_zone
  subnet_id         = module.vpc_stable.public_subnet_id
  root_volume_size  = 8

  security_group_ids = [
    module.vpc_stable.https_client_security_group_id,
    module.vpc_stable.github_client_security_group_id,
    module.drawbridge_stable.security_group_id,
  ]

  persistent_volume_ids = [
    module.helios_secrets_volume.id,
    module.helios_home_volume.id,
  ]

  zone_id   = module.cloud_zone.id
  zone_name = module.cloud_zone.name

  providers = {
    aws = aws.stable
  }
}

