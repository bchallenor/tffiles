provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "stable"
  region = "${var.stable_region}"
}

provider "aws" {
  alias  = "local"
  region = "${var.local_region}"
}

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
  bucket_name = "cloudtrail-${var.affix}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "billing_alarms" {
  source     = "./modules/billing_alarms"
  thresholds = [10, 20, 30, 40]
}

module "tfstate_bucket" {
  source = "./modules/s3_bucket"
  name   = "tfstate-${var.affix}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "photos_bucket" {
  source = "./modules/s3_bucket"
  name   = "photos-${var.affix}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "backups_bucket" {
  source = "./modules/s3_bucket"
  name   = "backups-${var.affix}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "annex_photos_bucket" {
  source = "./modules/s3_bucket"
  name   = "annex-photos-${var.affix}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "machine_images_bucket" {
  source = "./modules/s3_bucket"
  name   = "machine-images-${var.affix}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "drawbridge_dev" {
  source = "./modules/drawbridge"
  name   = "dev"

  providers = {
    "aws" = "aws.local"
  }
}

module "drawbridge_test" {
  source = "./modules/drawbridge"
  name   = "test"

  providers = {
    "aws" = "aws.stable"
  }
}
