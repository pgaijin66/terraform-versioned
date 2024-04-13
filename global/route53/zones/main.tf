resource "aws_route53_zone" "zone" {
  name    = var.name
  comment = var.comment

  dynamic "vpc" {
    for_each = var.vpc
    content {
      vpc_id = vpc.value
    }
  }

  force_destroy = var.force_destroy

  tags = var.tags
}

resource "aws_route53_zone_association" "secondary-vpcs" {
  for_each = toset(var.secondary_vpcs)
  zone_id  = aws_route53_zone.zone.zone_id
  vpc_id   = each.key
}
