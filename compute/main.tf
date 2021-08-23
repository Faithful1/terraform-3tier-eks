# --- compute/main.tf ---

data "aws_ami" "k3_ami" {
  most_recent = true //always confirm if you want the latest
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "random_id" "k3_node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "k3_pc_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "k3_node" {
  count                  = var.instance_count # 1
  instance_type          = var.instance_type  # t3.micro cos this is the min that supports containers
  ami                    = data.aws_ami.k3_ami.id
  key_name               = aws_key_pair.k3_pc_auth.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[count.index]
  user_data = templatefile(var.user_data_path,
    {
      nodename    = "k3-node-${random_id.k3_node_id[count.index].dec}"
      db_endpoint = var.db_endpoint
      dbuser      = var.dbuser
      dbpass      = var.dbpassword
      dbname      = var.dbname
    }
  )
  root_block_device {
    volume_size = var.vol_size # 10
  }
  tags = {
    Name = "k3_node-${random_id.k3_node_id[count.index].dec}"
  }
}
