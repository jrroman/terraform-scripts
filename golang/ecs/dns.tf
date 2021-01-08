data "aws_route53_zone" "main" {
  name         = "mdally.com."
  private_zone = false
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.id
  name    = "staging-api.${data.aws_route53_zone.main.name}"
  type    = "A"

  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = true
  }
}

