output "bastion_public_key_name" {
  description = "Bastion Host Public Key"
  value       = aws_key_pair.bastion_public_key.key_name
}
