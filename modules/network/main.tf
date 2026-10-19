# This module provides the isolated network and narrowly scoped ingress policy
# used by the WordPress application and its private RDS dependency.

resource "volcenginecc_vpc_vpc" "main" {
  vpc_name     = "${var.resource_prefix}-vpc"
  description  = "Network for the WordPress demonstration environment"
  cidr_block   = var.vpc_cidr
  enable_ipv_6 = false
  project_name = var.project_name

  tags = [
    for key, value in var.tags : {
      key   = key
      value = value
    }
  ]
}

resource "volcenginecc_vpc_subnet" "main" {
  vpc_id       = volcenginecc_vpc_vpc.main.vpc_id
  subnet_name  = "${var.resource_prefix}-subnet"
  description  = "Application and database subnet for WordPress"
  cidr_block   = var.subnet_cidr
  zone_id      = var.zone_id
  enable_ipv_6 = false

  tags = [
    for key, value in var.tags : {
      key   = key
      value = value
    }
  ]
}

resource "volcenginecc_vpc_security_group" "wordpress" {
  vpc_id              = volcenginecc_vpc_vpc.main.vpc_id
  security_group_name = "${var.resource_prefix}-web-sg"
  description         = "Restricted ingress for the WordPress web server"
  project_name        = var.project_name

  depends_on = [volcenginecc_vpc_subnet.main]

  ingress_permissions = [
    {
      description     = "HTTP from the public internet"
      direction       = "ingress"
      policy          = "accept"
      port_start      = 80
      port_end        = 80
      priority        = 10
      protocol        = "tcp"
      cidr_ip         = "0.0.0.0/0"
      prefix_list_id  = ""
      source_group_id = ""
    },
    {
      description     = "SSH from the configured administrator CIDR"
      direction       = "ingress"
      policy          = "accept"
      port_start      = 22
      port_end        = 22
      priority        = 20
      protocol        = "tcp"
      cidr_ip         = var.admin_cidr
      prefix_list_id  = ""
      source_group_id = ""
    }
  ]

  tags = [
    for key, value in var.tags : {
      key   = key
      value = value
    }
  ]
}
