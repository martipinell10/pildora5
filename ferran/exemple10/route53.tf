# Creació de una zona i subdomini per la resolució del DNS del load balancer.
resource "aws_route53_zone" "wp_zone" {
  name = var.domain
}

resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.wp_zone.zone_id
  name    = var.subdomain
  type    = "A"

  alias {
    name                   = aws_lb.wordpress_alb.dns_name
    zone_id                = aws_lb.wordpress_alb.zone_id
    evaluate_target_health = true
  }
}
