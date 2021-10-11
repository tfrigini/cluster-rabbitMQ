locals {
  vpc = var.vpc_id == null ? {} : {vpc_id = var.vpc_id}
}

resource "aws_route53_zone" "zone" {
  count = var.create ? 1 : 0
  name = var.route53_zone
  
  dynamic "vpc" {
    for_each = local.vpc
    content {
      vpc_id =  lookup(vpc.value, "vpc_id", null)
    }
  }

  tags = var.tags
}

resource "aws_route53_record" "routes" {
  count =  var. create && length(var.route53_records) > 0 ? length(var.route53_records) : 0

  zone_id = aws_route53_zone.zone[0].zone_id
  name    = var.route53_records[count.index]["name"]
  type    = var.route53_records[count.index]["type"]
  ttl     = var.route53_records[count.index]["ttl"]
  records = var.route53_records[count.index]["records"]
}