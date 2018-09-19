provider "aws" {
  region  = "us-east-1"
  version = "~> 1.33"
}

provider "aws" {
  alias   = "stable"
  region  = "${var.stable_region}"
  version = "~> 1.33"
}

provider "aws" {
  alias   = "local"
  region  = "${var.local_region}"
  version = "~> 1.33"
}

provider "archive" {
  version = "~> 1.1"
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

module "artifacts_bucket_stable" {
  source = "./modules/s3_bucket"
  name   = "artifacts-stable-${var.affix}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "artifacts_bucket_local" {
  source = "./modules/s3_bucket"
  name   = "artifacts-local-${var.affix}"

  providers = {
    "aws" = "aws.local"
  }
}

module "ami_importer_stable" {
  source      = "./modules/ami_importer"
  name        = "ami-importer-stable"
  bucket_name = "${module.artifacts_bucket_stable.id}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "ami_importer_local" {
  source      = "./modules/ami_importer"
  name        = "ami-importer-local"
  bucket_name = "${module.artifacts_bucket_local.id}"

  providers = {
    "aws" = "aws.local"
  }
}

module "registry_stable" {
  source = "./modules/ecr_registry"

  name = "stable"

  repos = [
    "nix-build/s3",
    "nix-build/ecr",
  ]

  providers = {
    "aws" = "aws.stable"
  }
}

module "registry_local" {
  source = "./modules/ecr_registry"

  name = "local"

  repos = [
    "nix-build/s3",
    "nix-build/ecr",
  ]

  providers = {
    "aws" = "aws.local"
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

module "intranet_stable" {
  source = "./modules/intranet"

  providers = {
    "aws" = "aws.stable"
  }
}

module "vpc_stable" {
  source            = "./modules/vpc"
  name              = "stable"
  availability_zone = "${var.stable_availability_zone}"

  providers = {
    "aws" = "aws.stable"
  }
}
