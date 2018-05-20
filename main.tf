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

module "drawbridge_dev" {
  source = "./modules/drawbridge"
  name   = "dev"
  region = "${var.local_region}"
}

module "drawbridge_test" {
  source = "./modules/drawbridge"
  name   = "test"
  region = "${var.stable_region}"
}
