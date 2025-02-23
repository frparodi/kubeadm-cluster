output "bastion_public_ip" {
  description = "Bastion Host Public IP"
  value       = aws_instance.bastion.public_ip
}

output "control_plane_internal_ip" {
  description = "Control Plane internal IP"
  value       = aws_instance.controlplane.private_ip
}
