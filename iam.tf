module "terraform_policy" {
  source = "./modules/terraform_policy"
}

module "ami_builder_policy" {
  source = "./modules/ami_builder_policy"
}

module "drawbridge_policy" {
  source = "./modules/drawbridge_policy"
}

module "drawbridge_test_policy" {
  source  = "./modules/drawbridge_policy"
  profile = "test"
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
    "${module.admin_role.assume_policy_arn}",
    "${module.terraform_policy.arn}",
    "${module.tfstate_bucket.read_policy_arn}",
  ]
}

module "nano_user" {
  source = "./modules/user"
  user   = "nano"

  policy_arns = [
    "${module.admin_role.assume_policy_arn}",
    "${module.terraform_policy.arn}",
    "${module.tfstate_bucket.read_policy_arn}",
    "${module.ami_builder_policy.arn}",
    "${module.drawbridge_test_policy.arn}",
    "${module.cloud_zone.bind_policy_arn}",
  ]
}

module "termux_phone_user" {
  source = "./modules/user"
  user   = "termux-phone"

  policy_arns = [
    "${module.drawbridge_policy.arn}",
    "${module.drawbridge_test_policy.arn}",
    "${module.cloud_zone.bind_policy_arn}",
  ]
}

module "drawbridge_user" {
  source = "./modules/user"
  user   = "drawbridge"

  policy_arns = [
    "${module.drawbridge_policy.arn}",
    "${module.cloud_zone.bind_policy_arn}",
  ]
}
