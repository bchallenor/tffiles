provider "aws" {
  region  = "us-east-1"
  version = "~> 2.41"
}

provider "aws" {
  alias   = "stable"
  region  = "${var.stable_region}"
  version = "~> 2.41"
}

provider "aws" {
  alias   = "local"
  region  = "${var.local_region}"
  version = "~> 2.41"
}

provider "archive" {
  version = "~> 1.1"
}

provider "external" {
  version = "~> 1.0"
}

provider "http" {
  version = "~> 1.0"
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

module "annex_archive_bucket" {
  source = "./modules/s3_bucket"
  name   = "annex-archive-${var.affix}"

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

  # TODO(v0.12): reduce once we can make noncurrent_version_transition a dynamic block
  noncurrent_version_expiration_days = 31

  providers = {
    "aws" = "aws.stable"
  }
}

module "artifacts_bucket_local" {
  source = "./modules/s3_bucket"
  name   = "artifacts-local-${var.affix}"

  # TODO(v0.12): reduce once we can make noncurrent_version_transition a dynamic block
  noncurrent_version_expiration_days = 31

  providers = {
    "aws" = "aws.local"
  }
}

module "nix_cache_bucket_stable" {
  source = "./modules/s3_cache_bucket"
  name   = "nix-cache-stable-${var.affix}"

  expiration_days = 28

  providers = {
    "aws" = "aws.stable"
  }
}

module "tmp_bucket" {
  source = "./modules/s3_cache_bucket"
  name   = "tmp-${var.affix}"

  expiration_days = 1

  providers = {
    "aws" = "aws.stable"
  }
}

module "amisync_stable" {
  source      = "./modules/amisync"
  name        = "amisync-stable"
  bucket_name = "${module.artifacts_bucket_stable.id}"

  providers = {
    "aws" = "aws.stable"
  }
}

module "amisync_local" {
  source      = "./modules/amisync"
  name        = "amisync-local"
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

module "task_cluster_stable" {
  source = "./modules/ecr_task_cluster"

  name = "nix-build"

  image_names = "${module.registry_stable.image_names}"

  cpu    = 2048
  memory = 4096

  exec_role_arn = "${module.registry_stable.exec_role_arn}"
  task_role_arn = "${module.nix_build_role.arn}"

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

module "vpc_stable" {
  source              = "./modules/vpc"
  name                = "stable"
  availability_zone   = "${var.stable_availability_zone}"
  vpn_ipv6_cidr_block = "fd00::/64"

  providers = {
    "aws" = "aws.stable"
  }
}

module "drawbridge_stable" {
  source = "./modules/drawbridge"
  name   = "stable"
  vpc_id = "${module.vpc_stable.vpc_id}"

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
