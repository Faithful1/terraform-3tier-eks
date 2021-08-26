# --- compute/output.tf ---

output "instance" {
    value = aws_instance.k3_node[*] // this will output everything and let us access it through the root output
    sensitive = true
}

output "instance_port" {
    value = aws_lb_target_group_attachment.k3_tg_attach[0].port // this will output everything and let us access it through the root output
    sensitive = true
}