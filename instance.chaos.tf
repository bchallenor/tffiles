module "chaos_secrets_volume" {
  source            = "./modules/volume"
  name              = "chaos-secrets"
  size              = 1
  availability_zone = var.stable_availability_zone

  providers = {
    aws = aws.stable
  }
}

module "chaos_home_volume" {
  source            = "./modules/volume"
  name              = "chaos-home"
  size              = 1
  availability_zone = var.stable_availability_zone

  providers = {
    aws = aws.stable
  }
}

module "chaos_instance" {
  source            = "./modules/instance"
  name              = "chaos"
  instance_type     = "t3.nano"
  availability_zone = var.stable_availability_zone
  subnet_id         = module.vpc_stable.public_subnet_id
  root_volume_size  = 4

  security_group_ids = [
    module.vpc_stable.https_client_security_group_id,
    module.vpc_stable.github_client_security_group_id,
    module.drawbridge_stable.security_group_id,
  ]

  persistent_volume_ids = [
    module.chaos_secrets_volume.id,
    module.chaos_home_volume.id,
  ]

  zone_id   = module.cloud_zone.id
  zone_name = module.cloud_zone.name

  providers = {
    aws = aws.stable
  }
}

