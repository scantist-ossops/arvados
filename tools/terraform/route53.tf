resource "aws_route53_zone" "private" {
  name          = var.r53_domain_name
  comment       = "Private ${var.r53_domain_name} AWS zone"

  vpc {
    vpc_id = var.manage_vpc ? module.vpc.*.vpc_id[0] : var.vpc_id
  }

  force_destroy = var.route53_force_destroy

  tags          = merge(
                        {"Name"    = var.r53_domain_name,
                         "Type"    = "private",
                         "Cluster" = var.cluster,
                        },
                        local.resource_tags,
                       )
}
resource "aws_route53_zone" "public" {
  name          = var.r53_domain_name
  comment       = "Public ${var.r53_domain_name} AWS zone"

  force_destroy = var.route53_force_destroy

  tags          = merge(
                        {"Name"    = var.r53_domain_name,
                         "Type"    = "public",
                         "Cluster" = var.cluster,
                        },
                        local.resource_tags,
                       )
}
