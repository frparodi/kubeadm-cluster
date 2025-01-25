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

resource "aws_security_group" "ingress_ssh" {
  name   = "ingress-ssh-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Login SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
}
