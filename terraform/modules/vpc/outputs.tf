output "vpc_id" {
  description = "ID of main VPC"
  value       = aws_vpc.main_vpc.id
}
