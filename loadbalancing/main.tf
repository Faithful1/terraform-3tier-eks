# --- loadbalancing/main.tf ---

resource "aws_lb" "k3_lb" {
  name               = "k3-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = var.public_sg
  idle_timeout = 400

  enable_deletion_protection = true

  tags = {
    Name = "k3_loadbalancer"
    Owner = "terraform"
  }
}