output "vpc_id" {
  description = "ID of main VPC"
  value       = aws_vpc.main_vpc.id
}

output "private_subnet_ids" {
  description = "Private subnet ids to be used by kubernetes (provided as a list)"
  value       = [aws_subnet.private_subnet.id, aws_subnet.private_subnet_secondary.id]
}
