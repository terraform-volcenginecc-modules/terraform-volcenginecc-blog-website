variable "region" {
  description = "Volcengine region in which to create the WordPress infrastructure."
  type        = string
  default     = "cn-beijing"
}

variable "zone_id" {
  description = "Availability zone for the subnet, ECS instance, and single-node RDS instance."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z0-9-]+-[a-z]$", var.zone_id))
    error_message = "zone_id must use a valid availability-zone format such as cn-beijing-a."
  }
}

variable "project_name" {
  description = "Short project identifier used in resource names and tags."
  type        = string
  default     = "wordpress"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,31}$", var.project_name))
    error_message = "project_name must start with a lowercase letter and contain 3-32 lowercase letters, digits, or hyphens."
  }
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "demo"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,15}$", var.environment))
    error_message = "environment must start with a lowercase letter and contain 2-16 lowercase letters, digits, or hyphens."
  }
}

variable "owner" {
  description = "Owner tag applied to supported resources."
  type        = string
}

variable "cost_center" {
  description = "Cost center tag applied to supported resources."
  type        = string
  default     = "shared"
}

variable "cloud_project_name" {
  description = "Volcengine project to which supported resources belong."
  type        = string
  default     = "default"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the WordPress VPC."
  type        = string
  default     = "10.20.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "subnet_cidr" {
  description = "IPv4 CIDR block for the application and database subnet."
  type        = string
  default     = "10.20.1.0/24"

  validation {
    condition     = can(cidrnetmask(var.subnet_cidr))
    error_message = "subnet_cidr must be a valid IPv4 CIDR block."
  }
}

variable "admin_cidr" {
  description = "IPv4 CIDR allowed to connect to ECS over SSH. Replace 0.0.0.0/0 with an approved management CIDR before publishing."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.admin_cidr))
    error_message = "admin_cidr must be a valid IPv4 CIDR."
  }
}

variable "image_id" {
  description = "Ubuntu 24.04 image ID available in the selected region."
  type        = string
}

variable "ecs_instance_type" {
  description = "ECS instance type available in the selected availability zone."
  type        = string
  default     = "ecs.g4i.large"
}

variable "ecs_login_mode" {
  description = "ECS login credential mode. Valid values are key_pair and password."
  type        = string
  default     = "password"

  validation {
    condition     = contains(["key_pair", "password"], var.ecs_login_mode)
    error_message = "ecs_login_mode must be either key_pair or password."
  }
}

variable "key_pair_name" {
  description = "Name of an existing ECS SSH key pair. Required only when ecs_login_mode is key_pair."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.key_pair_name == null ? true : length(trimspace(var.key_pair_name)) > 0
    error_message = "key_pair_name must be null or a non-empty ECS key pair name."
  }
}

variable "ecs_password" {
  description = "Initial ECS administrator password. The default is for demonstrations only; it is stored in Terraform state."
  type        = string
  default     = "ReplaceWithStrongPassword123"
  nullable    = true
  sensitive   = true

  validation {
    condition = var.ecs_password == null ? true : (
      length(var.ecs_password) >= 8 &&
      length(var.ecs_password) <= 30 &&
      (
        (length(regexall("[A-Z]", var.ecs_password)) > 0 ? 1 : 0) +
        (length(regexall("[a-z]", var.ecs_password)) > 0 ? 1 : 0) +
        (length(regexall("[0-9]", var.ecs_password)) > 0 ? 1 : 0) +
        (length(regexall("[^A-Za-z0-9]", var.ecs_password)) > 0 ? 1 : 0)
      ) >= 3 &&
      can(regex("^[A-Za-z0-9`~!@#$%^&*()_+={}\\[\\]:;'<>,.?/|\\-]+$", var.ecs_password)) &&
      !startswith(var.ecs_password, "/") &&
      !startswith(var.ecs_password, "$6$")
    )
    error_message = "ecs_password must be 8-30 characters, contain at least three character types, use only ECS-supported characters, and not start with / or $6$."
  }
}

variable "ecs_system_volume_type" {
  description = "ECS system volume type supported by the selected instance type."
  type        = string
  default     = "ESSD_FlexPL"
}

variable "ecs_system_volume_size_gb" {
  description = "ECS system volume size in GiB."
  type        = number
  default     = 40

  validation {
    condition     = var.ecs_system_volume_size_gb >= 40
    error_message = "ecs_system_volume_size_gb must be at least 40 GiB."
  }
}

variable "eip_bandwidth_mbps" {
  description = "Maximum bandwidth of the ECS public IP in Mbps."
  type        = number
  default     = 5

  validation {
    condition     = var.eip_bandwidth_mbps >= 1 && var.eip_bandwidth_mbps <= 200
    error_message = "eip_bandwidth_mbps must be between 1 and 200."
  }
}

variable "rds_node_spec" {
  description = "Single-node RDS MySQL specification available in the selected availability zone."
  type        = string
  default     = "rds.mysql.c.s.1c2g"
}

variable "rds_storage_space_gb" {
  description = "RDS MySQL storage size in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.rds_storage_space_gb >= 20
    error_message = "rds_storage_space_gb must be at least 20 GiB."
  }
}

variable "rds_deletion_protection" {
  description = "Whether RDS deletion protection is enabled."
  type        = bool
  default     = false
}

variable "database_name" {
  description = "WordPress database name created in RDS."
  type        = string
  default     = "wordpress"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_-]{0,62}[A-Za-z0-9]$", var.database_name))
    error_message = "database_name must be 2-64 characters, start with a letter, end with a letter or digit, and contain only letters, digits, underscores, or hyphens."
  }
}

variable "database_username" {
  description = "RDS super account used by WordPress."
  type        = string
  default     = "wordpress_app"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_-]{0,30}[A-Za-z0-9]$", var.database_username))
    error_message = "database_username must be 2-32 characters, start with a letter, end with a letter or digit, and contain only letters, digits, underscores, or hyphens."
  }
}

variable "database_password" {
  description = "Password for the WordPress RDS account. The default is for demonstrations only; it is stored in Terraform state and ECS user data."
  type        = string
  default     = "ReplaceWithStrongPassword123"
  sensitive   = true

  validation {
    condition = (
      length(var.database_password) >= 8 &&
      length(var.database_password) <= 32 &&
      length(regexall("[A-Z]", var.database_password)) > 0 &&
      length(regexall("[a-z]", var.database_password)) > 0 &&
      length(regexall("[0-9]", var.database_password)) > 0 &&
      can(regex("^[-A-Za-z0-9!@#$%^&*()_+=,.&?|/]+$", var.database_password))
    )
    error_message = "database_password must be 8-32 characters, include uppercase, lowercase, and numeric characters, and use only RDS-supported special characters."
  }
}

variable "wordpress_version" {
  description = "Pinned WordPress release installed by cloud-init."
  type        = string
  default     = "7.1.3"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.wordpress_version))
    error_message = "wordpress_version must be a three-part semantic version such as 7.1.3."
  }
}

variable "wordpress_sha256" {
  description = "SHA-256 checksum of the pinned WordPress tar.gz release archive."
  type        = string
  default     = "d2a09acb6a15e3b9c471d72557753c266d6f41a79ed19bfe04cbfe49e283b2a5"

  validation {
    condition     = can(regex("^[a-f0-9]{64}$", var.wordpress_sha256))
    error_message = "wordpress_sha256 must be the verified 64-character lowercase SHA-256 checksum."
  }
}

variable "additional_tags" {
  description = "Additional tags merged with the standard project tags."
  type        = map(string)
  default     = {}
}
