resource "aws_route53_zone_association" "association" {
  zone_id    = var.zoneId
  vpc_id     = var.vpcId
  vpc_region = var.region
}
