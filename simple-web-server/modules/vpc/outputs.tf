output "vpc_id" {
  description = "Custom VPC ID"
  value       = aws_vpc.main.id
}

// Output here to use in another module (ec2)
output "private_subnet_ids" {
  description = "Subnet IDs"
  value       = aws_subnet.private_subnets[*].id
}
