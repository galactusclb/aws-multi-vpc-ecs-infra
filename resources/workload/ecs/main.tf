resource "aws_ecs_cluster" "this" {
  name = "workload-ecs-cluster"
}

resource "aws_ecs_task_definition" "this" {
    family = "workload-ecs-task-definition"

    requires_compatibilities = [ "FARGATE" ]
    network_mode             = "awsvpc"
    cpu                      = 1024
    memory                   = 3072

    container_definitions = jsonencode([
        {
            name = "echoserver",
            # image = "k8s.gcr.io/e2e-test-images/echoserver:2.5",
            image = "nginx",
            cpu       = 256
            memory    = 512
            memoryReservation = 1048,
            portMappings = [
                {
                    containerPort = 80
                    hostPort      = 80
                }
            ]
            essential = true
        }
    ])

    runtime_platform {
      cpu_architecture = "X86_64"
      operating_system_family = "LINUX"
    }
}

resource "aws_security_group" "ecs-sg" {
  vpc_id = var.vpc_id

  tags = {
    Name = "ecs-sg"
  }
}

# for temporally
resource "aws_vpc_security_group_ingress_rule" "allow_tcp" {
  security_group_id = aws_security_group.ecs-sg.id

  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "TCP"
  from_port = 80
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_traffic" {
  security_group_id = aws_security_group.ecs-sg.id

  ip_protocol = "TCP"
  from_port = 80
  to_port = 80
  referenced_security_group_id = var.alb_sg_id
}

resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.ecs-sg.id

  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_ecs_service" "this" {
    name = "workload-ecs-task-definition-service"

    cluster = aws_ecs_cluster.this.id
    task_definition = aws_ecs_task_definition.this.arn

    desired_count = 2

    launch_type = "FARGATE"
    scheduling_strategy = "REPLICA"

    network_configuration {
      assign_public_ip = true
      security_groups  = [aws_security_group.ecs-sg.id]
      subnets = var.subnets
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.ecs-tg.arn
      container_name = "echoserver"
      container_port = var.listener_port
    }

    depends_on = [
      # Need to wait for alb target group
    ]
}

resource "aws_lb_target_group" "ecs-tg" {
  name        = "workload-ecs-tg"
  port = var.listener_port
  protocol    = "HTTP"
  target_type = "ip"

    vpc_id      = var.vpc_id

  health_check {
    protocol = "HTTP"
    path = "/"
    port = var.listener_port
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = var.alb_arn
  port = var.listener_port
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.ecs-tg.arn
  }
}