# This defines the variables commonly used in Jenkins.

variable "http" {
  type    = number
  default = 80
}

variable "https" {
  type    = number
  default = 443
}

variable "nfs" {
  type    = number
  default = 2049
}

variable "jenkins_port" {
  type    = number
  default = 8080
}

variable "jenkins_jnlp" {
  type    = number
  default = 50000
}
