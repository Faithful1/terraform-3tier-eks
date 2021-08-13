# --- networking/variables.tf ---

variable "vpc_cidr" {
  type = string
}

variable "owner" {
  type    = string
  default = "terraform"
}

variable "public_sn_count" {
  type = number
}

variable "private_sn_count" {
  type = number
}

variable "public_cidrs" {
  type = list(any)
}

variable "private_cidrs" {
  type = list(any)
}

