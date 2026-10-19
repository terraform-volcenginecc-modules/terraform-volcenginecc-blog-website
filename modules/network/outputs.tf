output "vpc_id" {
  description = "ID of the WordPress VPC."
  value       = volcenginecc_vpc_vpc.main.vpc_id
}

output "subnet_id" {
  description = "ID of the application and database subnet."
  value       = volcenginecc_vpc_subnet.main.subnet_id
}

output "security_group_id" {
  description = "ID of the WordPress ECS security group."
  value       = volcenginecc_vpc_security_group.wordpress.security_group_id
}
