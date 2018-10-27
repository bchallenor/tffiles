module "terraform_policy" {
  source = "./modules/terraform_policy"
}

module "ami_builder_policy" {
  source = "./modules/ami_builder_policy"
}

module "ec2_describe_policy" {
  source = "./modules/ec2_describe_policy"
}

module "admin_role" {
  source = "./modules/role"
  name   = "admin"

  policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
}

module "laptop_user" {
  source = "./modules/user"
  user   = "laptop"

  role_arns = [
    "${module.admin_role.arn}",
    "${module.ami_builder_role.arn}",
    "${module.amisync_stable.lambda_role_arn}",
    "${module.amisync_local.lambda_role_arn}",
    "${module.jenkins_role.arn}",
  ]

  policy_arns = [
    "${module.cloudtrail.bucket_read_policy_arn}",
    "${module.terraform_policy.arn}",
    "${module.tfstate_bucket.read_policy_arn}",
    "${module.drawbridge_dev.policy_arn}",
    "${module.drawbridge_stable.policy_arn}",
    "${module.cloud_zone.bind_policy_arn}",
  ]
}

module "laptop_annex_user" {
  source = "./modules/user"
  user   = "laptop-annex"

  policy_arns = [
    "${module.annex_archive_bucket.write_policy_arn}",
    "${module.annex_photos_bucket.write_policy_arn}",
  ]
}

module "nano_user" {
  source = "./modules/user"
  user   = "nano"

  role_arns = [
    "${module.admin_role.arn}",
  ]

  policy_arns = [
    "${module.cloudtrail.bucket_read_policy_arn}",
    "${module.terraform_policy.arn}",
    "${module.tfstate_bucket.read_policy_arn}",
    "${module.drawbridge_dev.policy_arn}",
    "${module.drawbridge_stable.policy_arn}",
    "${module.cloud_zone.bind_policy_arn}",
  ]
}

module "termux_phone_user" {
  source = "./modules/user"
  user   = "termux-phone"

  policy_arns = [
    "${module.drawbridge_dev.policy_arn}",
    "${module.drawbridge_stable.policy_arn}",
    "${module.cloud_zone.bind_policy_arn}",
  ]
}

module "ami_builder_role" {
  source = "./modules/role"
  name   = "ami-builder"

  create_instance_profile = true

  policy_arns = [
    "${module.ami_builder_policy.arn}",
    "${module.artifacts_bucket_stable.write_policy_arn}",
    "${module.artifacts_bucket_local.write_policy_arn}",
    "${module.registry_stable.push_policy_arn}",
    "${module.registry_local.push_policy_arn}",
  ]
}

module "jenkins_role" {
  source = "./modules/role"
  name   = "jenkins"

  create_instance_profile = true

  policy_arns = [
    "${module.artifacts_bucket_stable.write_policy_arn}",
    "${module.artifacts_bucket_local.write_policy_arn}",
    "${module.registry_stable.push_policy_arn}",
    "${module.registry_local.push_policy_arn}",
    "${module.ec2_describe_policy.arn}",
  ]
}
