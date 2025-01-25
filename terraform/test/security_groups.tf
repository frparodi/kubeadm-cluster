resource "aws_security_group" "egress_all" {
  name   = "egress-all-sg"
  vpc_id = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion_host" {
  name   = "bastion-host-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Login SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "control_plane" {
  name   = "control-plane-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Login SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [
      aws_security_group.bastion_host.id
    ]
  }

  ingress {
    description = "API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    description = "etcd"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
}

resource "aws_security_group" "weave" {
  name   = "weave-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Weave TCP"
    from_port   = 6783
    to_port     = 6783
    protocol    = "tcp"
    security_groups = [
      aws_security_group.control_plane.id,
      # aws_security_group.workernode.id
    ]
  }

  ingress {
    description = "Weave UDP"
    from_port   = 6783
    to_port     = 6784
    protocol    = "udp"
    security_groups = [
      aws_security_group.control_plane.id,
      # aws_security_group.workernode.id
    ]
  }
}
