locals {
  public_subnet_ids = [for name, id in var.jenkins_vpc_public_subnet_ids : id]
}

resource "aws_lb" "jenkins" {
  name               = "jenkins-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.jenkins_elb_sg_id]
  subnets            = local.public_subnet_ids

  tags = {
    Name = "Jenkins ALB"
  }
}

resource "aws_lb_target_group" "jenkins" {
  name        = "jenkins-alb-tg"
  port        = var.jenkins_port
  protocol    = "HTTP"
  vpc_id      = var.jenkins_vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    path                = "/login"
    port                = "8080"
    protocol            = "HTTP"
    timeout             = 10
  }

  tags = {
    Name = "Jenkins ALB Target Group"
  }
}

resource "aws_lb_listener" "jenkins" {
  load_balancer_arn = aws_lb.jenkins.arn
  port              = var.http
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }
}
