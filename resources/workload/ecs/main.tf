resource "aws_ecs_cluster" "this" {
  name = "workload-ecs-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family = "workload-ecs-task-definition"

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 3072

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "echoserver",
      # image = "k8s.gcr.io/e2e-test-images/echoserver:2.5",
      image = "registry.k8s.io/e2e-test-images/echoserver:2.5",
      # image = "nginx",
      cpu               = 256,
      memory            = 1048,
      memoryReservation = 512,
      portMappings = [
        {
          containerPort = 8080
        }
      ],
      essential = true
    }
  ])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

resource "aws_security_group" "ecs-sg" {
  vpc_id = var.vpc_id
  name   = "ecs-sg"

  tags = {
    Name = "ecs-sg"
  }
}

# for temporally
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.ecs-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080
}

# resource "aws_vpc_security_group_ingress_rule" "allow_alb_traffic" {
#   security_group_id = aws_security_group.ecs-sg.id

#   ip_protocol = "tcp"
#   from_port = 80
#   to_port = 80
#   referenced_security_group_id = var.alb_sg_id
# }

resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.ecs-sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_ecs_service" "this" {
  name = "workload-ecs-service"

  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn

  desired_count = 2

  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  network_configuration {
    assign_public_ip = false
    security_groups  = [aws_security_group.ecs-sg.id]
    subnets          = var.subnets
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-tg.arn
    container_name   = "echoserver"
    # container_port = var.listener_port
    container_port = 8080
  }

  depends_on = [
    # Need to wait for alb target group
  ]
}

resource "aws_lb_target_group" "ecs-tg" {
  name = "workload-ecs-tg"
  # port = var.listener_port
  port = 8080
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {
    protocol = "HTTP"
    path     = "/"
    # port = var.listener_port
    port = 8080
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = var.alb_arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-tg.arn
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
