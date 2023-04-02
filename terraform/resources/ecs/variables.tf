variable "jenkins_vpc_id" {
  type = string
}

variable "jenkins_vpc_private_subnet_ids" {
  type = map(any)
}

variable "jenkins_ecs_sg_id" {
  type = string
}

variable "jenkins_efs_id" {
  type = string
}

variable "jenkins_efs_access_point_id" {
  type = string
}

variable "jenkins_discovery_service_arn" {
  type = string
}

variable "jenkins_ecs_task_execution_role_arn" {
  type = string
}

variable "jenkins_ecs_task_role_arn" {
  type = string
}

variable "jenkins_alb_target_group_arn" {
  type = string
}

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

variable "jenkins_tasks" {
  type        = map(any)
  description = "Define an ECS task for Jenkins."

  default = {
    jenkins-master = {
      family         = "jenkins-master"
      image          = "jenkins/jenkins:lts"
      awslogs_prefix = "jenkins-master"
    }
    jenkins-agent = {
      family         = "jenkins-agent"
      image          = "jenkins/inbound-agent"
      awslogs_prefix = "jenkins-agent"
    }
  }
}
