# --- compute/main.tf ---

data "aws_ami" "k3_ami" {
  most_recent      = true //always confirm if you want the latest
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "random_id" "k3_node_id" {
  byte_length = 2
  count = var.instance_count
}

resource "aws_instance" "k3_node" {
    count = var.instance_count # 1
    instance_type = var.instance_type # t3.micro cos this is the min that supports containers
    ami = data.aws_ami.k3_ami

    tags = {
        Name = "k3_node-${random_id.k3_node_id[count.index].dec}"
    }

    # key_name = ""
    vpc_security_group_ids = [var.public_sg]
    subnet_id = var.public_subnets[count.index]

    # user_data = ""
    root_block_device {
        volume_size = var.vol_size # 10
    }
}