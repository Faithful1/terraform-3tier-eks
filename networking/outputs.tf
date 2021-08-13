# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.k3_vpc.id
}