resource "aws_route53_zone" "this" {
  name          = var.zone_name
  vpc {
    vpc_id = lookup(var.zone_config, "vpc_id")
  }

  comment       = lookup(var.zone_config, "comment", null)
  force_destroy = lookup(var.zone_config, "force_destroy", null)
  tags          = merge(
                        var.tags,
                        {"zone_scope" = "private"}
                       )
}
