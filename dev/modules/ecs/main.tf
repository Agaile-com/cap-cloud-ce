# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "ecs-${var.tenant_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.common_tags, {
    Name = "ecs-${var.tenant_name}"
  })
}

# ECS Task Definition
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.tenant_name}-ecs-task-tf"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name         = "${var.tenant_name}-container-tf"
      image        = var.container_image
      essential    = true
      environment  = var.container_environment
      secrets      = var.container_secrets
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.tenant_name}-ecs-svc-tf"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  tags = merge(var.common_tags, {
    Name = "${var.tenant_name}-ecs-task-tf"
  })

  lifecycle {
    ignore_changes = [
      tags,
      execution_role_arn
    ]
  }
}

# ECS Service
resource "aws_ecs_service" "main" {
  name                               = "${var.tenant_name}-ecs-svc-tf"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.main.arn
  desired_count                     = var.service_desired_count
  launch_type                       = "FARGATE"
  platform_version                  = "LATEST"
  health_check_grace_period_seconds = 60

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_tasks_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.tenant_name}-container-tf"
    container_port   = 3000
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      network_configuration,
      tags,
      deployment_circuit_breaker,
      task_definition
    ]
  }

  tags = merge(var.common_tags, {
    Name = "${var.tenant_name}-ecs-svc-tf"
  })
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.tenant_name}-ecs-svc-tf"
  retention_in_days = 1
  tags = var.common_tags
}

# Add variable for secrets
variable "container_secrets" {
  description = "The secrets to pass to the container"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
} 