resource "aws_s3_bucket" "terraform_state" {
  bucket = "kubecluster-tf-state"
}

module "vpc" {
  source = "../modules/vpc"

  namespace   = var.namespace
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  az_count    = var.az_count
}

module "keys" {
  source = "../modules/keys"

  key_name                = "bastion_key"
  store_local_private_key = true
}

resource "aws_instance" "bastion" {
  instance_type = "t3.small"
  ami           = data.aws_ami.ubuntu.image_id
  key_name      = module.keys.bastion_public_key_name

  subnet_id = module.vpc.public_subnets[0]

  vpc_security_group_ids = [
    aws_security_group.egress_all.id,
    aws_security_group.ingress_ssh.id
  ]

  user_data = <<-EOT
              #!/usr/bin/env bash
              hostnamectl set-hostname bastion
              echo "PRIMARY_IP=$(ip route | grep default | awk '{ print $9 }')" >> /etc/environment
              EOT

  tags = {
    "Name" = "bastion"
  }
}
