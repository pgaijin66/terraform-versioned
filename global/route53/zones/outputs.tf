output "zone_id" {
  value       = aws_route53_zone.zone.zone_id
  description = "The ID of the hosted zone that is being created."
}

output "name_servers" {
  value       = aws_route53_zone.zone.name_servers
  description = "A list of name servers in associated (or default) delegation set."
}

output "name" {
  value       = aws_route53_zone.zone.name
  description = "The domain name of the route53 hosted zone."
}
