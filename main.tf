module "root_zone" {
  source = "./modules/dns_zone"
  name   = "${var.domain}."
}

module "cloud_zone" {
  source       = "./modules/dns_zone"
  parent_id    = "${module.root_zone.id}"
  name         = "cloud.${module.root_zone.name}"
  negative_ttl = 10
}

module "google_mx" {
  source    = "./modules/dns_google_mx"
  zone_id   = "${module.root_zone.id}"
  zone_name = "${module.root_zone.name}"
}

module "cloudtrail" {
  source      = "./modules/cloudtrail"
  home_region = "${var.stable_region}"
  bucket_name = "cloudtrail-${var.affix}"
}

module "billing_alarms" {
  source     = "./modules/billing_alarms"
  thresholds = [10, 20, 30, 40]
}

module "tfstate_bucket" {
  source = "./modules/s3_bucket"
  name   = "tfstate-${var.affix}"
  region = "${var.stable_region}"
}

module "photos_bucket" {
  source = "./modules/s3_bucket"
  name   = "photos-${var.affix}"
  region = "${var.stable_region}"
}

module "backups_bucket" {
  source = "./modules/s3_bucket"
  name   = "backups-${var.affix}"
  region = "${var.stable_region}"
}

module "data_volume" {
  source            = "./modules/volume"
  name              = "data"
  size              = 64
  region            = "${var.stable_region}"
  availability_zone = "${var.stable_availability_zone}"
}

module "drawbridge" {
  source = "./modules/drawbridge"
  region = "${var.local_region}"
}

module "drawbridge_x" {
  source  = "./modules/drawbridge"
  profile = "x"
  region  = "${var.local_region}"
}

module "drawbridge_test" {
  source  = "./modules/drawbridge"
  profile = "test"
  region  = "${var.stable_region}"
}

module "vault_bucket" {
  source = "./modules/s3_bucket"
  name   = "vault-${var.affix}"
  region = "${var.stable_region}"
}

module "vault_host" {
  source            = "./modules/vault_host"
  name              = "vault"
  region            = "${var.stable_region}"
  availability_zone = "${var.stable_availability_zone}"
  bucket_name        = "${module.vault_bucket.id}"
  profile_name      = "${module.vault_profile.profile_name}"
  ssh_public_key    = "${var.ssh_public_key}"
  zone_id           = "${module.cloud_zone.id}"
  zone_name         = "${module.cloud_zone.name}"
}
