### GENERAL
aws_profile              = "arvados-playground"
aws_region               = "us-east-1"
environment              = "production"
namespace                = "3rd-party deploy test"

### KEYPAIR
enable_key_pair          = true
key_name                 = "javier"
key_path                 = "~/.ssh/id_rsa.pub"

cluster                  = "vwxyz"

# VPC
# If you have/want to use a VPC already defined, set this value to false
# and uncomment and provide values for the following variables

manage_vpc               = true
vpc_id                   = "vpc-0c42c0d442b6e69f0"
private_subnets_ids      = ["subnet-0e9f42997a17b89ed"]
compute_subnets_ids      = ["subnet-08ee1640d915736e2"]
public_subnets_ids       = ["subnet-029286e3665e4a6b5"]

cluster_cidr             = "10.0.0.0/16"
azs                      = ["us-east-1a"]
private_subnets          = ["10.0.255.0/24"]
compute_subnets          = ["10.0.254.0/24"]
public_subnets           = ["10.0.0.0/24"]
enable_nat_gateway       = true
enable_vpn_gateway       = false
single_nat_gateway       = true
one_nat_gateway_per_az   = false
enable_dhcp_options      = true
r53_domain_name          = "arvados.test"

instance_type = {
  "default"   = "m5a.large",
  # "api"       = "m5a.large",
  # "shell"     = "m5a.large",
  # "keepproxy" = "m5a.large",
  # "keepstore" = "m5a.large",
  # "workbench" = "m5a.large",
  # "database"  = "m5a.large",
}
instance_ami = {
  "default"   = "ami-07d02ee1eeb0c996c",
  # "api"       = "ami-07d02ee1eeb0c996c",
  # "shell"     = "ami-07d02ee1eeb0c996c",
  # "keepstore" = "ami-07d02ee1eeb0c996c",
  # "keepproxy" = "ami-07d02ee1eeb0c996c",
  # "workbench" = "ami-07d02ee1eeb0c996c",
  # "database"  = "ami-07d02ee1eeb0c996c",
}

# KEEPSTORE/s
keepstore_count = 2

# SECURITY
# CIDRs allowed unrestricted access to the instances
allowed_access_cidrs = ["186.123.88.103/32"]

# If you have/want to use already defined security groups, set this value to false
# and uncomment and provide values for the following variables
manage_security_groups = true
vpc_security_group_ids = {
  "ssh"        = "sg-01234567890123456",
  "http"       = "sg-12345678901234567",
  "https"      = "sg-23456789012345678",
  "webshell"   = "sg-34567890123456789",
  "postgresql" = "sg-45678901234567890",
  "keepstore"  = "sg-56789012345678901",
}
