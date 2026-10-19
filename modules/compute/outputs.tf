output "instance_id" {
  description = "ID of the WordPress ECS instance."
  value       = volcenginecc_ecs_instance.wordpress.instance_id
}

output "private_ip" {
  description = "Primary private IP address of the WordPress ECS instance."
  value       = volcenginecc_ecs_instance.wordpress.primary_network_interface.primary_ip_address
}

output "public_ip" {
  description = "Public IP address attached to the WordPress ECS instance."
  value       = volcenginecc_ecs_instance.wordpress.eip_address.ip_address
}
