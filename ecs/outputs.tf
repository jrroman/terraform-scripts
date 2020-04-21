output "alb_hostname" {
  value = aws_alb.main.dns_name
}

output "full_dns_record" {
  value = aws_route53_record.main.fqdn
}
