module "api" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.17.0"

  name                   = "${var.cluster}-api"
  instance_count         = 1

  iam_instance_profile   = "dispatcher_instance_profile"
  ami                    = try(var.instance_ami["api"], var.instance_ami["default"])
  instance_type          = try(var.instance_type["api"], var.instance_type["default"])
  key_name               = var.key_pair
  monitoring             = true

  tags                    = merge({"Name": "${var.cluster}-api",
                                   "OsType": "LINUX"}, local.resource_tags)
  volume_tags             = merge({"Name": "${var.cluster}-api"}, local.resource_tags)

  network_interface       = [{
    device_index = 0,
    network_interface_id = aws_network_interface.api.id,
  }]

  # associate_public_ip_address = false
  ebs_optimized           = true
  # user_data             = templatefile("_bin/user_data.sh", { VM = "${var.api_name}.${var.cluster}" })

  root_block_device           = [{
    encrypted             = true,
    kms_key_id            = var.kms_key_id,
    volume_size           = var.root_bd_size,
    delete_on_termination = true,
  }]
  ebs_block_device            = [{
    encrypted             = true,
    kms_key_id            = var.kms_key_id,
    volume_size           = var.data_bd_size,
    delete_on_termination = true,
    device_name           = "xvdh",
  }]
}

resource "aws_eip" "cluster_api_public_ip" {
  vpc      = true
  instance = module.api.id[0]
  network_interface = aws_network_interface.api.id
  tags     = merge({"Name": "${var.cluster}-api-ip"},local.resource_tags)
}

resource "aws_network_interface" "api" {
  subnet_id       = var.manage_vpc ? module.vpc.0.public_subnets[0] : var.public_subnets_ids[0]
  # private_ips     = [cidrhost(var.vpc_subnet_cidrs[0], var.host_number["api"])]
  security_groups = [
                     local.ssh_sg,
                     local.http_sg,
                     local.https_sg,
                    ]
  tags           = merge({"Name": "${var.cluster}-api"}, local.resource_tags)
}
