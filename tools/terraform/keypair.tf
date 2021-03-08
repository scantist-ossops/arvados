module "keypair" {
  source          = "clouddrove/keypair/aws"
  version         = "0.14.0"
  key_path        = var.key_path
  key_name        = var.key_name
  enable_key_pair = var.enable_key_pair
  tags            = local.resource_tags
}
