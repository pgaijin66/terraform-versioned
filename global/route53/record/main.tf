locals {
  name         = trimsuffix(var.name, ".")
  sliced       = split(".", local.name)
  tld_sections = var.private ? 3 : 2
  tld          = var.tld != null ? var.tld : join(".", concat(slice(local.sliced, length(local.sliced) - local.tld_sections, length(local.sliced))))
}

data "aws_route53_zone" "this" {
  name         = local.tld
  private_zone = var.private
}

resource "aws_route53_record" "basic" {
  count   = var.alias_name == null && var.alias_zone == null && var.ignore_record_value_changes == false ? 1 : 0
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.name
  type    = upper(var.type)
  ttl     = var.ttl
  records = var.records
}

resource "aws_route53_record" "ignore_changes" {
  count   = var.alias_name == null && var.alias_zone == null && var.ignore_record_value_changes == true ? 1 : 0
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.name
  type    = upper(var.type)
  ttl     = var.ttl
  records = var.records
  lifecycle {
    ignore_changes = [
      records
    ]
  }
}

resource "aws_route53_record" "alias" {
  count   = var.alias_name != null && var.alias_zone != null && var.ignore_record_value_changes == false ? 1 : 0
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.name
  type    = upper(var.type)

  alias {
    name                   = var.alias_name
    zone_id                = var.alias_zone
    evaluate_target_health = var.alias_evaluate
  }
}
