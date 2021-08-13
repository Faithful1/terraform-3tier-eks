# --- root/variables.tf ---

variable "aws_region" {
  default = "us-west-2"
}

// This information will be found in the terraform.tfvars
variable "access_ip" {
  type = string
}

# --- database variables ---
variable "dbname" {
  type = string
}

variable "dbuser" {
  type = string
  sensitive = true
}

variable "dbpassword" {
  type = string
  sensitive = true
}
