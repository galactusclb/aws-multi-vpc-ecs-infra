output "nlb_dns_name" {
  value = aws_lb.workload-nlb.dns_name
}

output "nlb_arn" {
  value = aws_lb.workload-nlb.arn
}

output "nlb_sg_id" {
  value = aws_security_group.nlb-sg.id
}