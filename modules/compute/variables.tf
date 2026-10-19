variable "resource_prefix" {
  description = "Prefix used for compute resource names."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC containing ECS."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet containing ECS."
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group attached to ECS."
  type        = string
}

variable "zone_id" {
  description = "Availability zone for ECS."
  type        = string
}

variable "image_id" {
  description = "Ubuntu 24.04 image ID."
  type        = string
}

variable "instance_type" {
  description = "ECS instance type."
  type        = string
}

variable "login_mode" {
  description = "ECS login credential mode."
  type        = string

  validation {
    condition     = contains(["key_pair", "password"], var.login_mode)
    error_message = "login_mode must be either key_pair or password."
  }
}

variable "key_pair_name" {
  description = "Name of an existing ECS SSH key pair when login_mode is key_pair."
  type        = string
  nullable    = true
}

variable "password" {
  description = "Initial ECS administrator password when login_mode is password. This value is stored in Terraform state."
  type        = string
  nullable    = true
  sensitive   = true
}

variable "system_volume_type" {
  description = "ECS system volume type."
  type        = string
}

variable "system_volume_size_gb" {
  description = "ECS system volume size in GiB."
  type        = number
}

variable "eip_bandwidth_mbps" {
  description = "Maximum public bandwidth in Mbps."
  type        = number
}

variable "wordpress_version" {
  description = "Pinned WordPress release."
  type        = string
}

variable "wordpress_sha256" {
  description = "SHA-256 checksum of the WordPress tar.gz archive."
  type        = string
}

variable "database_host" {
  description = "Private RDS endpoint."
  type        = string
}

variable "database_port" {
  description = "Private RDS endpoint port."
  type        = number
}

variable "database_name" {
  description = "WordPress database name."
  type        = string
}

variable "database_username" {
  description = "WordPress RDS account name."
  type        = string
}

variable "database_password" {
  description = "WordPress RDS account password. This value is embedded in ECS user data and stored in Terraform state."
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Volcengine project name."
  type        = string
}

variable "tags" {
  description = "Tags applied to the ECS instance."
  type        = map(string)
}
