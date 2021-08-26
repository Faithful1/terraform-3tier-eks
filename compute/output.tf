# --- compute/output.tf ---

output "instance" {
    value = aws_instance.k3_node[*] // this will output everything and let us access it through the root output
    sensitive = true
}