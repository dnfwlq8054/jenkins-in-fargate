locals {
  private_subnets = [for name, id in var.jenkins_vpc_private_subnet_ids : id]
}

resource "aws_cloudwatch_log_group" "jenkins_ecs" {
  name              = "/ecs/jenkins"
  retention_in_days = 7

  tags = {
    Name = "Jenkins ECS Log Group"
  }
}

resource "aws_ecs_cluster" "jenkins" {
  name = "jenkins-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "Jenkins ECS Cluster"
  }
}

resource "aws_ecs_task_definition" "jenkins" {
  for_each                 = var.jenkins_tasks
  family                   = each.value.family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = var.jenkins_ecs_task_execution_role_arn
  task_role_arn            = var.jenkins_ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = each.key
      image     = each.value.image
      essential = true
      portMappings = [
        {
          containerPort = var.jenkins_port
          hostPort      = var.jenkins_port
          protocol      = "tcp"
        },
        {
          containerPort = var.jenkins_jnlp
          hostPort      = var.jenkins_jnlp
          protocol      = "tcp"
        },
        {
          containerPort = var.http
          hostPort      = var.http
          protocol      = "tcp"
        },
        {
          containerPort = var.https
          hostPort      = var.https
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.jenkins_ecs.name
          awslogs-region        = "ap-northeast-2"
          awslogs-stream-prefix = each.value.awslogs_prefix
        }
      }
      mountPoints = [
        {
          containerPath = "/var/jenkins_home"
          sourceVolume  = "jenkins_home"
        }
      ]
    }
  ])

  volume {
    name = "jenkins_home"

    efs_volume_configuration {
      file_system_id     = var.jenkins_efs_id
      transit_encryption = "ENABLED"

      authorization_config {
        access_point_id = var.jenkins_efs_access_point_id
        iam             = "ENABLED"
      }
    }
  }
}

resource "aws_ecs_service" "jenkins" {
  name                               = "jenkins-service"
  cluster                            = aws_ecs_cluster.jenkins.id
  task_definition                    = aws_ecs_task_definition.jenkins["jenkins-master"].arn
  desired_count                      = 1
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets          = local.private_subnets
    security_groups  = [var.jenkins_ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.jenkins_alb_target_group_arn
    container_name   = "jenkins-master"
    container_port   = var.jenkins_port
  }

  service_registries {
    registry_arn = var.jenkins_discovery_service_arn
  }

  tags = {
    Name = "Jenkins ECS Service"
  }
}
