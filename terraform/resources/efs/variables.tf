# Define a variable to create resources in the Jenkins EFS.

variable "jenkins_vpc_private_subnet_ids" {
  type        = map(any)
  description = "Value of jenkins vpc private subnet ids"
}

variable "jenkins_efs_sg_id" {
  type        = string
  description = "Value of jenkins efs security group id"
}
