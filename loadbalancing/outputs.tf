# --- loadbalancing/outputs.tf ---

output "lb_target_group_arn" {
    value = aws_lb_target_group.k3_tg.arn
} 