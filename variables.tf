# --- root/variables.tf ---

variable "aws_region" {
  default = "us-west-2"
}

// This information will be found in the terraform.tfvars
variable "access_ip" {
  type = string
}