# --- database/outputs.tf ---

output "db_endpoint" {
  value = aws_db_instance.k3_db.endpoint
}

# output "dbname" {
#   value = aws_db_instance.k3_db.name
# }

# output "dbuser" {
#   value = aws_db_instance.k3_db.username
# }

# output "dbpassword" {
#   value = aws_db_instance.k3_db.endpoint
# }