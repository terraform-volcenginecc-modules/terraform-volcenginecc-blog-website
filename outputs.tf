output "wordpress_url" {
  description = "Public HTTP URL for the WordPress installation page."
  value       = "http://${module.compute.public_ip}/"
}

output "ecs_instance_id" {
  description = "ID of the WordPress ECS instance."
  value       = module.compute.instance_id
}

output "ecs_private_ip" {
  description = "Private IP address of the WordPress ECS instance."
  value       = module.compute.private_ip
}

output "ecs_public_ip" {
  description = "Public IP address of the WordPress ECS instance."
  value       = module.compute.public_ip
}

output "rds_instance_id" {
  description = "ID of the RDS MySQL instance."
  value       = module.database.instance_id
}

output "rds_connection_addresses" {
  description = "Private RDS connection records used by WordPress."
  value       = module.database.connection_addresses
}

output "database_name" {
  description = "Database created for WordPress."
  value       = module.database.database_name
}

output "database_username" {
  description = "RDS super account created for WordPress."
  value       = module.database.account_name
}

output "wordpress_initialization" {
  description = "Next step after infrastructure deployment."
  value       = "Open http://${module.compute.public_ip}/wp-admin/install.php to create the WordPress administrator."
}
