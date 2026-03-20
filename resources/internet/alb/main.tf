resource "aws_lb" "internet-alb" {
    name = "internet-alb"
    load_balancer_type = "application"
    internal = false

    security_groups = []
    subnets = var.subnets

    enable_deletion_protection = false
    enable_cross_zone_load_balancing = true

    tags = {
        Name= "internet-alb"
    }
}

# resource "aws_lb_target_group" "name" {
  
# }

# resource "aws_lb_listener" "name" {
  
# }