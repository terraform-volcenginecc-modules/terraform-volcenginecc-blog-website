output "instance_id" {
  description = "ID of the RDS MySQL instance."
  value       = volcenginecc_rdsmysql_instance.main.instance_id
}

output "connection_addresses" {
  description = "Private connection records reported by RDS."
  value       = volcenginecc_rdsmysql_instance.main.address_objects
}

output "private_host" {
  description = "Private RDS endpoint used by WordPress."
  value       = local.private_addresses[0].domain
}

output "private_port" {
  description = "Private RDS endpoint port used by WordPress."
  value       = tonumber(local.private_addresses[0].port)
}

output "database_name" {
  description = "Name of the WordPress database."
  value       = volcenginecc_rdsmysql_database.wordpress.name
}

output "account_name" {
  description = "Name of the RDS super account used by WordPress."
  value       = volcenginecc_rdsmysql_db_account.wordpress.account_name
}

output "allow_list_id" {
  description = "ID of the RDS allowlist restricted to the application subnet."
  value       = volcenginecc_rdsmysql_allow_list.application.allow_list_id
}
