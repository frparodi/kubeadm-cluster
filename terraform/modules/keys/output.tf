output "public_key_name" {
  description = "Public Key Name"
  value       = aws_key_pair.this.key_name
}

output "private_key_pem" {
  description = "Private Key pem"
  value       = tls_private_key.this.private_key_pem
}
