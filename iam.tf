module "terraform_policy" {
  source = "./modules/terraform_policy"
}

module "ami_builder_policy" {
  source = "./modules/ami_builder_policy"
}

module "self_management_policy" {
  source = "./modules/self_management_policy"
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

  policy_arns = [
    "${module.self_management_policy.arn}",
    "${module.admin_role.assume_policy_arn}",
    "${module.terraform_policy.arn}",
    "${module.tfstate_bucket.read_policy_arn}",
    "${module.drawbridge_dev.policy_arn}",
    "${module.drawbridge_test.policy_arn}",
    "${module.cloud_zone.bind_policy_arn}",
  ]
}

module "nano_user" {
  source = "./modules/user"
  user   = "nano"

  policy_arns = [
    "${module.self_management_policy.arn}",
    "${module.admin_role.assume_policy_arn}",
    "${module.terraform_policy.arn}",
    "${module.tfstate_bucket.read_policy_arn}",
    "${module.ami_builder_policy.arn}",
    "${module.drawbridge_dev.policy_arn}",
    "${module.drawbridge_test.policy_arn}",
    "${module.cloud_zone.bind_policy_arn}",
  ]
}

module "termux_phone_user" {
  source = "./modules/user"
  user   = "termux-phone"

  policy_arns = [
    "${module.drawbridge_dev.policy_arn}",
    "${module.drawbridge_test.policy_arn}",
    "${module.cloud_zone.bind_policy_arn}",
  ]
}

module "ami_builder_profile" {
  source = "./modules/instance_profile"
  name   = "ami-builder"

  policy_arns = [
    "${module.ami_builder_policy.arn}",
  ]
}
