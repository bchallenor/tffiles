resource "aws_route53_zone" "zone" {
  name = var.name
}

# Note that Terraform sorts the name_servers list,
# so the first NS in the list may not be the same NS that AWS chose in the default SOA record.
# But this does not seem to matter.
resource "aws_route53_record" "soa" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = aws_route53_zone.zone.name
  type    = "SOA"
  ttl     = "900"
  records = ["${aws_route53_zone.zone.name_servers[0]}. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 ${var.negative_ttl}"]
}

resource "aws_route53_record" "parent_ns" {
  count   = var.parent_id != "" ? 1 : 0
  zone_id = var.parent_id
  name    = aws_route53_zone.zone.name
  type    = "NS"
  ttl     = "3600"
  records = aws_route53_zone.zone.name_servers
}

