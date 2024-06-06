resource "aws_cloudwatch_log_group" "HERO-INFRA-VAR-SERVICE-NAME" {
  name = "/ecs/cluster/HERO-INFRA-VAR-SERVICE-NAME"
}

resource "aws_ecs_task_definition" "HERO-INFRA-VAR-SERVICE-NAME" {
  family                   = "task_definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name         = "container"
      image        = "thimovss/hero-infra:0.0.1"
      cpu          = 256
      memory       = 512
      essential    = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.HERO-INFRA-VAR-SERVICE-NAME.name
          "awslogs-region"        = var.AWS_REGION
          "awslogs-stream-prefix" = "ecs"
        }
      }
    },
  ])
}

resource "aws_ecs_service" "HERO-INFRA-VAR-SERVICE-NAME" {
  name            = "HERO-INFRA-VAR-SERVICE-NAME"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.HERO-INFRA-VAR-SERVICE-NAME.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.subnet.id]
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = true
  }
}
