# Description: Terraform main file

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      Make    = "Terraform"
      Project = "Jenkins"
    }
  }
}

module "jenkins_vpc" {
  source = "./resources/vpc"
}

module "jenkins_sg" {
  source = "./resources/sg"

  jenkins_vpc_id = module.jenkins_vpc.vpc_id

  http         = var.http
  https        = var.https
  nfs          = var.nfs
  jenkins_port = var.jenkins_port
  jenkins_jnlp = var.jenkins_jnlp
}

module "jenkins_efs" {
  source = "./resources/efs"

  jenkins_efs_sg_id              = module.jenkins_sg.efs_sg_id
  jenkins_vpc_private_subnet_ids = module.jenkins_vpc.private_subnet_ids
}

module "jenkins_cloud_map" {
  source = "./resources/cloud_map"

  jenkins_vpc_id = module.jenkins_vpc.vpc_id
}

module "jenkins_iam" {
  source = "./resources/iam"

  jenkins_efs_arn = module.jenkins_efs.efs_arn

}

module "jenkins_elb" {
  source = "./resources/elb"

  jenkins_vpc_public_subnet_ids = module.jenkins_vpc.public_subnet_ids
  jenkins_elb_sg_id             = module.jenkins_sg.elb_sg_id
  jenkins_vpc_id                = module.jenkins_vpc.vpc_id

  http         = var.http
  jenkins_port = var.jenkins_port
}

module "jenkins_ecs" {
  source = "./resources/ecs"

  jenkins_vpc_private_subnet_ids      = module.jenkins_vpc.private_subnet_ids
  jenkins_ecs_sg_id                   = module.jenkins_sg.ecs_sg_id
  jenkins_vpc_id                      = module.jenkins_vpc.vpc_id
  jenkins_efs_id                      = module.jenkins_efs.efs_id
  jenkins_efs_access_point_id         = module.jenkins_efs.efs_access_point_id
  jenkins_alb_target_group_arn        = module.jenkins_elb.alb_target_group_arn
  jenkins_discovery_service_arn       = module.jenkins_cloud_map.jenkins_discovery_service_arn
  jenkins_ecs_task_execution_role_arn = module.jenkins_iam.ecs_task_execution_role_arn
  jenkins_ecs_task_role_arn           = module.jenkins_iam.ecs_task_role_arn

  http         = var.http
  https        = var.https
  nfs          = var.nfs
  jenkins_port = var.jenkins_port
  jenkins_jnlp = var.jenkins_jnlp
}
