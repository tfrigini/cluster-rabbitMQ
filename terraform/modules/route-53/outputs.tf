output "zone_id" {
  description = "Zone Id od the created zone"
  value = try(aws_route53_zone.zone[0].zone_id, null)
}