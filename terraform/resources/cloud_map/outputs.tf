output "jenkins_discovery_service_arn" {
  value       = aws_service_discovery_service.jenkins.arn
  description = "Value of jenkins discovery service arn"
}
