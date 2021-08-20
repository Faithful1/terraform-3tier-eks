# --- loadbalancing/main.tf ---

resource "aws_lb" "k3_lb" {
  name                       = "k3-loadbalancer"
  subnets                    = var.public_subnets
  security_groups            = var.public_sg
  idle_timeout               = 400
  load_balancer_type         = "application"
  enable_deletion_protection = true

  tags = {
    Name  = "k3_loadbalancer"
    Owner = "terraform"
  }
}

resource "aws_lb_target_group" "k3_tg" {
  name     = "k3-lb-tg-${substr(uuid(), 0, 3)}"
  port     = var.tg_port     #80
  protocol = var.tg_protocol #http
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }

  tags = {
    Name  = "k3_target_group"
    Owner = "terraform"
  }
}
