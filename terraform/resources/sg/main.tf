# Defines the security group for all the resources used in Jenkins.

locals {
  jenkins_efs_sg = {
    jenkins_ecs_ingress = {
      description = "Allow Jenkins ECS to access Jenkins EFS"
      port        = var.nfs
      sg_id       = aws_security_group.jenkins_ecs.id
      type        = "ingress"
      cidr_blocks = null
    }
    jenkins_ec2_bastion_ingress = {
      description = "Allow Jenkins EC2 Bastion to access Jenkins EFS"
      port        = var.nfs
      sg_id       = aws_security_group.jenkins_ec2_bastion.id
      type        = "ingress"
      cidr_blocks = null
    }
  }

  jenkins_ecs_sg = {
    jenkins_port_self_ingress = {
      port        = var.jenkins_port
      type        = "ingress"
      description = "Allow Jenkins Port self ingress"
      cidr_blocks = null
      sg_id       = aws_security_group.jenkins_ecs.id
    }
    jenkins_jnlp_self_ingress = {
      port        = var.jenkins_jnlp
      type        = "ingress"
      description = "Allow Jenkins JNLP self ingress"
      cidr_blocks = null
      sg_id       = aws_security_group.jenkins_ecs.id
    }
    jenkins_elb_ingress = {
      port        = var.jenkins_port
      type        = "ingress"
      description = "Allow Jenkins ELB to access Jenkins ECS"
      cidr_blocks = null
      sg_id       = aws_security_group.jenkins_alb.id
    }
    jenkins_port_self_egress = {
      port        = var.jenkins_port
      type        = "egress"
      description = "Allow Jenkins Port self egress"
      cidr_blocks = null
      sg_id       = aws_security_group.jenkins_ecs.id
    }
    jenkins_jnlp_self_egress = {
      port        = var.jenkins_jnlp
      type        = "egress"
      description = "Allow Jenkins JNLP self egress"
      cidr_blocks = null
      sg_id       = aws_security_group.jenkins_ecs.id
    }
    jenkins_efs_egress = {
      port        = var.nfs
      type        = "egress"
      description = "Allow Jenkins EFS to access Jenkins ECS"
      cidr_blocks = null
      sg_id       = aws_security_group.jenkins_efs.id
    }
    http_egress = {
      port        = var.http
      type        = "egress"
      description = "Allow HTTP egress"
      cidr_blocks = ["0.0.0.0/0"]
      sg_id       = null
    }
    https_egress = {
      port        = var.https
      type        = "egress"
      description = "Allow HTTPS egress"
      cidr_blocks = ["0.0.0.0/0"]
      sg_id       = null
    }
  }

  jenkins_elb_sg = {
    http_ingress = {
      port        = var.http
      type        = "ingress"
      description = "Allow HTTP ingress"
      cidr_blocks = ["0.0.0.0/0"]
      sg_id       = null
    }
    https_ingress = {
      port        = var.https
      type        = "ingress"
      description = "Allow HTTPS ingress"
      cidr_blocks = ["0.0.0.0/0"]
      sg_id       = null
    }
    jenkins_egress = {
      port        = var.jenkins_port
      type        = "egress"
      description = "Allow Jenkins egress"
      cidr_blocks = null
      sg_id       = aws_security_group.jenkins_ecs.id
    }
  }
}

# Define Jenkins EFS security group
resource "aws_security_group" "jenkins_efs" {
  name        = "jenkins-efs"
  description = "Security group for Jenkins EFS"
  vpc_id      = var.jenkins_vpc_id

  tags = {
    Name = "Jenkins EFS Security Group"
  }
}

resource "aws_security_group_rule" "jenkins_efs" {
  for_each                 = local.jenkins_efs_sg
  type                     = each.value.type
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins_efs.id
  source_security_group_id = each.value.sg_id
  cidr_blocks              = each.value.cidr_blocks
  description              = each.value.description
}


# Define Jenkins ECS security group
resource "aws_security_group" "jenkins_ecs" {
  name        = "jenkins-ecs"
  description = "Security group for Jenkins ECS"
  vpc_id      = var.jenkins_vpc_id

  tags = {
    Name = "Jenkins ECS Security Group"
  }
}

resource "aws_security_group_rule" "jenkins_ecs" {
  for_each                 = local.jenkins_ecs_sg
  type                     = each.value.type
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins_ecs.id
  source_security_group_id = each.value.sg_id
  cidr_blocks              = each.value.cidr_blocks
  description              = each.value.description
}


# Define Jenkins ELB security group
resource "aws_security_group" "jenkins_alb" {
  name        = "jenkins-alb"
  description = "Security group for Jenkins ALB"
  vpc_id      = var.jenkins_vpc_id

  tags = {
    Name = "Jenkins ALB Security Group"
  }
}

resource "aws_security_group_rule" "jenkins_alb" {
  for_each                 = local.jenkins_elb_sg
  type                     = each.value.type
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.jenkins_alb.id
  source_security_group_id = each.value.sg_id
  cidr_blocks              = each.value.cidr_blocks
  description              = each.value.description
}


# Define Jenkins EC2 Bastion security group
resource "aws_security_group" "jenkins_ec2_bastion" {
  name        = "jenkins-ec2-bastion"
  description = "Security group for Jenkins ECS"
  vpc_id      = var.jenkins_vpc_id

  tags = {
    Name = "Jenkins EC2 Bastion Security Group"
  }
}
