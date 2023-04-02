output "efs_arn" {
  value       = aws_efs_file_system.jenkins.arn
  description = "Value of jenkins efs arn"
}

output "efs_id" {
  value       = aws_efs_file_system.jenkins.id
  description = "Value of jenkins efs id"
}

output "efs_access_point_id" {
  value       = aws_efs_access_point.jenkins.id
  description = "Value of jenkins access point id"
}
