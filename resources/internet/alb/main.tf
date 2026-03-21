data "external" "nlb_ips" {
  # depends_on = [var.nlb_dependency]

  # program = [
  #   "bash",
  #   "${path.module}/scripts/get_nlb_ips.sh",
  #   var.workload_nlb_name,
  #   "us-east-1"
  # ]

  # program = [
  #   "C:/Program Files/Git/bin/bash.exe",
  #   "${path.module}/scripts/get_nlb_ips.sh",
  #   var.workload_nlb_name,
  #   "us-east-1"
  # ]

  program = [
    "C:/Program Files/Git/bin/bash.exe",
    "${path.module}/scripts/get_nlb_ips.sh",
    var.workload_nlb_name,
    "us-east-1"
  ]
}

locals {
  # nlb_private_ips = data.external.nlb_ips.result.ips
  # nlb_private_ips =  split(",", data.external.nlb_ips.result.ips)
  nlb_private_ips = compact(split(",", data.external.nlb_ips.result.ips))
}


resource "aws_security_group" "alb-sg" {
    vpc_id = var.vpc_id
    name = "internet-alb-sg"

    tags = {
        Name = "internet-alb-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_internet_traffic" {
  security_group_id = aws_security_group.alb-sg.id

  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
}

resource "aws_vpc_security_group_egress_rule" "outbound-traffic" {
  security_group_id = aws_security_group.alb-sg.id

  cidr_ipv4 = var.workload_vpc_cidr
  ip_protocol = "tcp"
  from_port = 80
  to_port = 80
}

resource "aws_lb" "internet-alb" {
    name = "internet-alb"
    load_balancer_type = "application"
    internal = false

    security_groups = [aws_security_group.alb-sg.id]
    subnets = var.subnets

    # enable_deletion_protection = false
    # enable_cross_zone_load_balancing = true

    tags = {
        Name= "internet-alb"
    }
}

resource "aws_lb_target_group" "to_workload_nlb" {
  target_type = "ip"
  name        = "to-workload-nlb"
  port        = 80
  protocol    = "HTTP"

  vpc_id = var.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "nlb_ip_1" {
  target_group_arn = aws_lb_target_group.to_workload_nlb.arn
  target_id        = local.nlb_private_ips[0]
  availability_zone = "us-east-1a"
  port             = 80
}

# resource "aws_lb_target_group_attachment" "nlb_ip_2" {
#   target_group_arn = aws_lb_target_group.to_workload_nlb.arn
#   target_id        = local.nlb_private_ips[1]
#   port             = 80
# }

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.internet-alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.to_workload_nlb.arn
  }
}