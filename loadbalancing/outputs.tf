# --- loadbalancing/outputs.tf ---

output "lb_target_group_arn" {
    value = aws_lb_target_group.k3_tg.arn
}

output "lb_endpoint" {
    value = aws_lb.k3_lb.dns_name
}