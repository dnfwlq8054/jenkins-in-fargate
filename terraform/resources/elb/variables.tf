variable "http" {
  type = number
}

variable "jenkins_port" {
  type = number
}

variable "jenkins_vpc_id" {
  type = string
}

variable "jenkins_vpc_public_subnet_ids" {
  type = map(any)
}

variable "jenkins_elb_sg_id" {
  type = string
}
