locals {
  ecs_task_inline_policy = {
    jenkins-efs = {
      actions = [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:ClientRootAccess",
        "elasticfilesystem:ClientRead"
      ]
      resources = [
        var.jenkins_efs_arn
      ]
    }
    jenkins-ecs = {
      actions = [
        "ecs:RegisterTaskDefinition",
        "ecs:DescribeTaskDefinition",
        "ecs:DescribeContainerInstances",
        "ecs:DescribeTasks",
        "ecs:DeregisterTaskDefinition",
        "ecs:ListClusters",
        "ecs:RunTask",
        "ecs:StopTask"
      ]
      resources = [
        "*"
      ]
    }
    jenkins-iam = {
      actions = [
        "iam:PassRole",
        "iam:GetRole"
      ]
      resources = [
        "*"
      ]
    }
  }
}

data "aws_iam_policy" "ecs_task_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "jenkins_ecs_task_execution" {
  name = "jenkins_ecs_task_execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    data.aws_iam_policy.ecs_task_execution.arn
  ]

  tags = {
    Name = "Jenkins ECS Task Execution Role"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "jenkins_ecs_task" {
  name = "jenkins_ecs_task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  dynamic "inline_policy" {
    for_each = local.ecs_task_inline_policy

    content {
      name = inline_policy.key

      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Action   = inline_policy.value.actions
            Effect   = "Allow"
            Resource = inline_policy.value.resources
          }
        ]
      })
    }
  }

  tags = {
    Name = "Jenkins ECS Task Role"
  }

  lifecycle {
    create_before_destroy = true
  }
}
