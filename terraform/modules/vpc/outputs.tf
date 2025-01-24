output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnets" {
  description = "List of public subnets ids"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of private subnets ids"
  value       = aws_subnet.private[*].id
}
