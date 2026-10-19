variable "resource_prefix" {
  description = "Prefix used for database resource names."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC containing RDS."
  type        = string
}

variable "subnet_id" {
  description = "ID of the private subnet containing RDS."
  type        = string
}

variable "application_cidr" {
  description = "Application subnet CIDR allowed to connect to MySQL."
  type        = string
}

variable "zone_id" {
  description = "Availability zone for the single RDS node."
  type        = string
}

variable "node_spec" {
  description = "RDS MySQL node specification."
  type        = string
}

variable "storage_space_gb" {
  description = "RDS storage size in GiB."
  type        = number
}

variable "database_name" {
  description = "Database created for WordPress."
  type        = string
}

variable "account_name" {
  description = "RDS super account used by WordPress."
  type        = string
}

variable "account_password" {
  description = "Password for the WordPress RDS account. This value is stored in Terraform state."
  type        = string
  sensitive   = true
}

variable "deletion_protection" {
  description = "Whether RDS deletion protection is enabled."
  type        = bool
}

variable "project_name" {
  description = "Volcengine project name."
  type        = string
}

variable "tags" {
  description = "Tags applied to supported database resources."
  type        = map(string)
}
