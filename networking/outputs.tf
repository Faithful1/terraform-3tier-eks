# --- networking/outputs.tf ---

output "vpc_id" {
  value = aws_vpc.k3_vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.k3_rds_subnet_group.*.name
}

output "db_security_group_id" {
  value = [aws_security_group.k3_sg["rds"].id]
}