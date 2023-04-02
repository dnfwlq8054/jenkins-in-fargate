output "efs_sg_id" {
  value       = aws_security_group.jenkins_efs.id
  description = "Value of jenkins efs security group id"
}

output "ecs_sg_id" {
  value       = aws_security_group.jenkins_ecs.id
  description = "Value of jenkins ecs security group id"
}

output "elb_sg_id" {
  value       = aws_security_group.jenkins_alb.id
  description = "Value of jenkins elb security group id"
}
