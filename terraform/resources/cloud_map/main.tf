# Define Jenkins Cloud Map

resource "aws_service_discovery_private_dns_namespace" "jenkins" {
  name        = "local.com"
  vpc         = var.jenkins_vpc_id
  description = "Jenkins Cloud Map"

  tags = {
    Name = "Jenkins Cloud Map"
  }
}

resource "aws_service_discovery_service" "jenkins" {
  name = "jenkins"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.jenkins.id

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }

  tags = {
    Name = "Jenkins Cloud Map"
  }
}
