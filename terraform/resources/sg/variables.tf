# Define the ports used in the Jenkins security group.

variable "http" {
  type = number
}

variable "https" {
  type = number
}

variable "nfs" {
  type = number
}

variable "jenkins_port" {
  type = number
}

variable "jenkins_jnlp" {
  type = number
}

variable "jenkins_vpc_id" {
  type = string
}
