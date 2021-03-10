resource "aws_route53_zone" "this" {
  name          = var.zone_name
  comment       = lookup(var.zone_config, "comment", null)
  force_destroy = lookup(var.zone_config, "force_destroy", null)
  tags          = merge(
                        var.tags,
                        {"ZoneScope" = "public"}
                       )
}
