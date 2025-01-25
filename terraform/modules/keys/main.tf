# Generate SSH Key
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store private key locally
resource "local_sensitive_file" "this" {
  count = var.store_local_private_key ? 1 : 0

  filename        = pathexpand("~/.ssh/${var.key_name}.pem")
  file_permission = "600"
  content         = tls_private_key.this.private_key_pem
}

# Upload public key to AWS
resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = trimspace(tls_private_key.this.public_key_openssh)
}
