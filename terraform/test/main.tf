resource "aws_s3_bucket" "terraform_state" {
  bucket = "kubecluster-tf-state"
}

# --------------------------------------------------------------------------------------------------------
# VPC
# --------------------------------------------------------------------------------------------------------

module "vpc" {
  source = "../modules/vpc"

  namespace   = var.namespace
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  az_count    = var.az_count
}

# --------------------------------------------------------------------------------------------------------
# Keys
# --------------------------------------------------------------------------------------------------------

module "bastion_keys" {
  source = "../modules/keys"

  key_name = "bastion_keys"

  store_local_private_key = true
}

module "cluster_nodes_keys" {
  source = "../modules/keys"

  key_name = "cluster_nodes_keys"
}

# --------------------------------------------------------------------------------------------------------
# Control Plane
# --------------------------------------------------------------------------------------------------------

# Create network interface for Control Plane node
resource "aws_network_interface" "control_plane_eni" {
  subnet_id = module.vpc.private_subnets[0]
  security_groups = [
    aws_security_group.egress_all.id,
    aws_security_group.control_plane.id,
    aws_security_group.weave.id
  ]

  tags = {
    Name = "control-plane-eni"
  }
}

resource "aws_instance" "controlplane" {
  instance_type = "t3.medium"
  ami           = data.aws_ami.ubuntu.image_id
  key_name      = module.cluster_nodes_keys.public_key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.control_plane_eni.id // Attach network interface to instance
  }

  user_data = <<-EOT
              #!/usr/bin/env bash
              hostnamectl set-hostname controlplane
              echo "PRIMARY_IP=$(ip route | grep default | awk '{ print $9 }')" >> /etc/environment
              EOT

  tags = {
    "Name" = "controlplane"
  }
}

# --------------------------------------------------------------------------------------------------------
# Bastion Host
# --------------------------------------------------------------------------------------------------------

resource "aws_instance" "bastion" {
  instance_type = "t3.small"
  ami           = data.aws_ami.ubuntu.image_id
  key_name      = module.bastion_keys.public_key_name

  subnet_id = module.vpc.public_subnets[0]

  vpc_security_group_ids = [
    aws_security_group.egress_all.id,
    aws_security_group.bastion_host.id
  ]

  user_data = <<-EOT
              #!/usr/bin/env bash
              hostnamectl set-hostname bastion
              echo "${module.cluster_nodes_keys.private_key_pem}" > /home/ubuntu/.ssh/id_rsa
              chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
              chmod 600 /home/ubuntu/.ssh/id_rsa
              echo "PRIMARY_IP=$(ip route | grep default | awk '{ print $9 }')" >> /etc/environment
              cat <<EOF >> /etc/hosts
              ${aws_network_interface.control_plane_eni.private_ip} controlplane
              EOF
              EOT

  tags = {
    "Name" = "bastion"
  }
}
