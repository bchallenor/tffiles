module "param_store_key" {
  source = "./modules/key"
  name   = "param-store"

  providers = {
    "aws" = "aws.stable"
  }
}
