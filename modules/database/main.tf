# This module creates a private, single-node MySQL database and a WordPress
# super account. The account password is stored in Terraform state.

resource "volcenginecc_rdsmysql_allow_list" "application" {
  allow_list_name = "${var.resource_prefix}-app-allowlist"
  allow_list_desc = "WordPress application subnet only"
  allow_list_type = "IPv4"
  allow_list      = [var.application_cidr]
  project_name    = var.project_name
}

resource "volcenginecc_rdsmysql_instance" "main" {
  instance_name              = "${var.resource_prefix}-mysql"
  instance_type              = "SingleNode"
  db_engine_version          = "MySQL_8_0"
  storage_type               = "CloudESSD_PL0"
  storage_space              = var.storage_space_gb
  vpc_id                     = var.vpc_id
  subnet_id                  = var.subnet_id
  port                       = 3306
  allow_list_ids             = [volcenginecc_rdsmysql_allow_list.application.allow_list_id]
  deletion_protection        = var.deletion_protection ? "Enabled" : "Disabled"
  project_name               = var.project_name
  auto_upgrade_minor_version = "Auto"

  nodes = [
    {
      node_type = "Primary"
      node_spec = var.node_spec
      zone_id   = var.zone_id
    }
  ]

  charge_detail = {
    charge_type = "PostPaid"
    auto_renew  = false
    number      = 1
  }

  tags = [
    for key, value in var.tags : {
      key   = key
      value = value
    }
  ]
}

resource "volcenginecc_rdsmysql_database" "wordpress" {
  instance_id        = volcenginecc_rdsmysql_instance.main.instance_id
  name               = var.database_name
  character_set_name = "utf8mb4"
  description        = "WordPress application database"
}

resource "volcenginecc_rdsmysql_db_account" "wordpress" {
  instance_id      = volcenginecc_rdsmysql_instance.main.instance_id
  account_name     = var.account_name
  account_password = var.account_password
  account_type     = "Super"
  account_desc     = "WordPress application super account"
  host             = "%"

  depends_on = [volcenginecc_rdsmysql_database.wordpress]
}

locals {
  private_addresses = flatten([
    for endpoint in volcenginecc_rdsmysql_instance.main.endpoints : [
      for address in endpoint.addresses : address
      if address.network_type == "Private"
    ]
  ])
}
