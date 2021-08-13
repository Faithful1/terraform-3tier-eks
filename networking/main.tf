# --- networking/main.tf ---

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "k3_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name  = "k3_vpc_${random_integer.random.id}"
    Owner = var.owner
  }
}

resource "aws_subnet" "public" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.k3_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"][count.index]

  tags = {
    Name  = "k3_public_subnet_${count.index + 1}"
    Owner = "terraform"
  }
}

resource "aws_subnet" "private" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.k3_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false //defaults to fault already
  availability_zone       = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"][count.index]

  tags = {
    Name  = "k3_private_subnet_${count.index + 1}"
    Owner = "terraform"
  }
}
