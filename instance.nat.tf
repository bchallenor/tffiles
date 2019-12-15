module "nat_secrets_volume" {
  source            = "./modules/volume"
  name              = "nat-secrets"
  size              = 1
  availability_zone = var.stable_availability_zone

  providers = {
    aws = aws.stable
  }
}

module "nat_instance" {
  source            = "./modules/instance"
  name              = "nat"
  instance_type     = "t3.nano"
  availability_zone = var.stable_availability_zone
  subnet_id         = module.vpc_stable.public_subnet_id
  root_volume_size  = 4

  security_group_ids = [
    module.vpc_stable.public_nat_server_security_group_id,
    module.vpc_stable.github_client_security_group_id,
    module.drawbridge_stable.security_group_id,
  ]

  persistent_volume_ids = [
    module.nat_secrets_volume.id,
  ]

  persistent_network_interface_ids = [
    module.vpc_stable.private_nat_server_network_interface_id,
  ]

  zone_id   = module.cloud_zone.id
  zone_name = module.cloud_zone.name

  providers = {
    aws = aws.stable
  }
}

