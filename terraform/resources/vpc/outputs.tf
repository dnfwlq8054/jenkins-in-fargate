output "vpc_id" {
  value       = aws_vpc.jenkins.id
  description = "Value of jenkins vpc id"
}

output "private_subnet_ids" {
  value       = { for key, subnet in aws_subnet.jenkins_vpc_private : key => subnet.id }
  description = <<-EOT
    Value of jenkins vpc private subnet ids
    Data format set as follows:
    {
      "private_subnet_az_a" = "subnet_id",
      "private_subnet_az_c" = "subnet_id"
    }
  EOT
}

output "public_subnet_ids" {
  value       = { for key, subnet in aws_subnet.jenkins_vpc_public : key => subnet.id }
  description = <<-EOT
    Value of jenkins vpc public subnet ids
    Data format set as follows:
    {
      "public_subnet_az_a" = "subnet_id",
      "public_subnet_az_c" = "subnet_id"
    }
  EOT
}
