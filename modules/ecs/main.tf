# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "patient-service-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name        = "patient-service-cluster"
  }
}


# ECS Task Definition for Patient Service
resource "aws_ecs_task_definition" "patient_service" {
  family                   = "patient-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn           = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "patient-service"
      image = "${var.ecr_patient_repo_url}:latest"
      
      portMappings = [
        {
          containerPort = var.app_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
        awslogs-group = aws_cloudwatch_log_group.patient_log_group.name,
        awslogs-region = var.region,
        awslogs-stream-prefix = "ecs"
      }
    }
    }
  ])

  tags = {
    Name        = "patient-service-task"
  }
}

# ECS Task Definition for Appointment Service
resource "aws_ecs_task_definition" "appointment_service" {
  family                   = "appointment-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn           = var.task_role_arn

  container_definitions = jsonencode([
    {
      name  = "appointment-service"
      image = "${var.ecr_appointment_repo_url}:latest"
      
      portMappings = [
        {
          containerPort = var.app_port
          protocol      = "tcp"
        }
      ]

      
    logConfiguration = {
        logDriver = "awslogs",
        options = {
        awslogs-group = aws_cloudwatch_log_group.appointment_log_group.name,
        awslogs-region = var.region,
        awslogs-stream-prefix = "ecs"
      }
    }


    }
  ])

  tags = {
    Name        = "appointment-service-task"
  }
}

# ECS Service for Patient Service
resource "aws_ecs_service" "patient_service" {
  name            = "patient-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.patient_service.arn
  desired_count   = var.desired_capacity
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_security_group_id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arns.patient_service
    container_name   = "patient-service"
    container_port   = var.app_port
  }

  depends_on = [var.target_group_arns]

  tags = {
    Name        = "patient-service"
  }
}

# ECS Service for Appointment Service
resource "aws_ecs_service" "appointment_service" {
  name            = "appointment-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.appointment_service.arn
  desired_count   = var.desired_capacity
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [var.ecs_security_group_id]
    subnets          = var.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arns.appointment_service
    container_name   = "appointment-service"
    container_port   = var.app_port
  }

  depends_on = [var.target_group_arns]

  tags = {
    Name        = "appointment-service"
  }
}

# creation Log-group for patient service

resource "aws_cloudwatch_log_group" "patient_log_group" {
 name = "/ecs/patient_log_group"
 retention_in_days = 7
 tags = {
    Name        = "patient_service_log_group"

  }
}

# creation Log-group for appointtment service
resource "aws_cloudwatch_log_group" "appointment_log_group" {
 name = "/ecs/appointment_log_group"
 retention_in_days = 7
 tags = {
    Name        = "appointment_service_log_group"

  }
}