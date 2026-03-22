output "alb_dns_name" {
  value = aws_lb.internet-alb.dns_name
}

output "alb_arn" {
  value = aws_lb.internet-alb.arn
}