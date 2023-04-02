output "ecs_task_execution_role_arn" {
  value       = aws_iam_role.jenkins_ecs_task_execution.arn
  description = "Value of jenkins ecs task execution role arn"
}

output "ecs_task_role_arn" {
  value       = aws_iam_role.jenkins_ecs_task.arn
  description = "Value of jenkins ecs task role arn"
}
