resource "aws_security_group" "alb-sg" {
  vpc_id = var.vpc_id
  name   = "internet-alb-sg"

  tags = {
    Name = "internet-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_internet_traffic" {
  security_group_id = aws_security_group.alb-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "outbound-traffic" {
  security_group_id = aws_security_group.alb-sg.id

  cidr_ipv4   = var.workload_vpc_cidr
  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
}

resource "aws_lb" "internet-alb" {
  name               = "internet-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.alb-sg.id]
  subnets         = var.subnets

  
  # enable_cross_zone_load_balancing = true

  tags = {
    Name = "internet-alb"
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

resource "aws_lb_target_group_attachment" "alb_to_nlb_attachment_1" {
  target_group_arn = aws_lb_target_group.to_workload_nlb.arn
  target_id        = "10.0.1.10"
  port             = 80
  availability_zone = "all"
}

resource "aws_lb_target_group_attachment" "alb_to_nlb_attachment_2" {
  target_group_arn = aws_lb_target_group.to_workload_nlb.arn
  target_id        = "10.0.2.10"
  availability_zone = "all"
  port             = 80
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.internet-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.to_workload_nlb.arn
  }
}
