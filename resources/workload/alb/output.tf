output "alb_arn" {
  value = aws_alb.this.arn
}

output "alb_dns_name" {
  value = aws_alb.this.dns_name
}

output "alb_sg_id" {
  value = aws_alb.this.id
}