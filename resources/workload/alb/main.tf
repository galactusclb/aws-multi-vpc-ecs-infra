resource "aws_alb" "this" {
    name = "workload-alb"
    internal           = true
    load_balancer_type = "application"
    subnets = var.subnets
    security_groups = [aws_security_group.alb-sg.id]

    enable_cross_zone_load_balancing = true
    enable_deletion_protection       = false

    tags = {
        Name= "workload-alb"
    }
}

resource "aws_security_group" "alb-sg" {
    name = "alb-sg"
    vpc_id = var.vpc_id
    description = "Allow TLS inbound traffic and all outbound traffic"

    tags = {
        Name = "alb-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_nlb_traffic" {
    description = "Allow ingress from NLB"
    security_group_id = aws_security_group.alb-sg.id

    # ToDo Debug
    # referenced_security_group_id = var.alb_sg_ingress_id
    cidr_ipv4 = "0.0.0.0/0"
    # cidr_ipv4 = "0.0.0.0/16"
    from_port = var.alb_sg_ingress_from_port
    to_port = var.alb_sg_ingress_to_port
    ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
    security_group_id = aws_security_group.alb-sg.id

    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = -1
    description = "Allow all outbound"
}