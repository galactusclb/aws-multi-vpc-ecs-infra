resource "aws_lb_target_group" "nlb_tg" {
  name        = "workload-nlb-tg"
  port        = var.listener_port
  protocol    = "TCP"
  target_type = "alb"

  vpc_id = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = var.listener_port
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment_alb" {
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = var.alb_arn
  port             = var.listener_port
}


resource "aws_lb" "workload-nlb" {
  name               = "workload-nlb"
  load_balancer_type = "network"
  internal           = true

  ip_address_type = "ipv4"
  # subnets         = var.nlb_subnets

  subnet_mapping {
    subnet_id            = var.nlb_subnets[0]
    private_ipv4_address = var.frontend_private_ips[0]
  }

  subnet_mapping {
    subnet_id            = var.nlb_subnets[1]
    private_ipv4_address = var.frontend_private_ips[1]
  }

  security_groups = [aws_security_group.nlb-sg.id]

  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false
}

resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.workload-nlb.arn
  port              = var.listener_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

resource "aws_security_group" "nlb-sg" {
  vpc_id = var.vpc_id
  name   = "nlb-sg"

  tags = {
    Name = "nlb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nlb-sg-allow-http" {
  security_group_id = aws_security_group.nlb-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "TCP"
  from_port   = var.listener_port
  to_port     = var.listener_port
}

resource "aws_vpc_security_group_egress_rule" "allow-outbound" {
  security_group_id = aws_security_group.nlb-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
  description = "Allow all outbound"
}
