output "alb_target_group_arn" {
  value       = aws_lb_target_group.jenkins.arn
  description = "Value of jenkins alb target group arn"
}
