# --- networking/main.tf ---

# Declare the data source
data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "public_az" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "k3_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name  = "k3_vpc_${random_integer.random.id}"
    Owner = var.owner
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ADD THE SUBNETS
resource "aws_subnet" "k3_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.k3_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.public_az.result[count.index]

  tags = {
    Name  = "k3_public_subnet_${count.index + 1}"
    Owner = "terraform"
  }
}

resource "aws_subnet" "k3_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.k3_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.public_az.result[count.index]

  tags = {
    Name  = "k3_private_subnet_${count.index + 1}"
    Owner = "terraform"
  }
}

# DB SUBNET GROUP
resource "aws_db_subnet_group" "k3_rds_subnet_group" {
  count      = var.db_subnet_group ? 1 : 0
  name       = "k3_rds_subnet_group"
  subnet_ids = aws_subnet.k3_private_subnet.*.id

  tags = {
    Name  = "k3_rds_subnet_group"
    Owner = "terraform"
  }
}

# ADD THE INTERNET GATEWAY
resource "aws_internet_gateway" "k3_internet_gateway" {
  vpc_id = aws_vpc.k3_vpc.id

  tags = {
    Name  = "k3_igw"
    owner = "terraform"
  }
}

# ADD public ROUTE TABLE
resource "aws_route_table" "k3_public_rt" {
  vpc_id = aws_vpc.k3_vpc.id

  tags = {
    Name  = "k3_public_rt"
    owner = "terraform"
  }
}

//this is the route table that the subnet will use if not explicitly associated 
resource "aws_route" "default_route" { 
  route_table_id         = aws_route_table.k3_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.k3_internet_gateway.id
}

# ADD private ROUTE TABLE
//every vpc has a default rt and we are specifying that the default rt by vpc 
//should be default for all of our resources | we can create ours if we want

resource "aws_default_route_table" "k3_private_rt" {
  default_route_table_id = aws_vpc.k3_vpc.default_route_table_id

  tags = {
    Name  = "k3_private_rt"
    owner = "terraform"
  }
}

resource "aws_route_table_association" "k3_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.k3_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.k3_public_rt.id
}



# ADD SECURITY GROUP

resource "aws_security_group" "k3_sg" {
  for_each    = var.security_groups
  name        = each.value.name        //"k3_public_sg"
  description = each.value.description //"Allow For Public Access"
  vpc_id      = aws_vpc.k3_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress = [
    {
      description      = "Allow SSH Traffic From VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      security_groups  = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      self             = null
    }
  ]

  tags = {
    Owner = "terraform"
  }
}
