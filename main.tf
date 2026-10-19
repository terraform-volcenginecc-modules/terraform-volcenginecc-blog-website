module "network" {
  source = "./modules/network"

  resource_prefix = local.resource_prefix
  vpc_cidr        = var.vpc_cidr
  subnet_cidr     = var.subnet_cidr
  zone_id         = var.zone_id
  admin_cidr      = var.admin_cidr
  project_name    = var.cloud_project_name
  tags            = local.common_tags
}

# Allow the ECS primary ENI and its security-group association to reach a
# stable deleted state before the network module removes the security group.
# Only destroy_duration is set, so normal creation is not delayed.
resource "time_sleep" "before_security_group_destroy" {
  destroy_duration = "60s"

  depends_on = [module.network]
}

module "database" {
  source = "./modules/database"

  resource_prefix     = local.resource_prefix
  vpc_id              = module.network.vpc_id
  subnet_id           = module.network.subnet_id
  application_cidr    = var.subnet_cidr
  zone_id             = var.zone_id
  node_spec           = var.rds_node_spec
  storage_space_gb    = var.rds_storage_space_gb
  database_name       = var.database_name
  account_name        = var.database_username
  account_password    = var.database_password
  deletion_protection = var.rds_deletion_protection
  project_name        = var.cloud_project_name
  tags                = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  resource_prefix       = local.resource_prefix
  vpc_id                = module.network.vpc_id
  subnet_id             = module.network.subnet_id
  security_group_id     = module.network.security_group_id
  zone_id               = var.zone_id
  image_id              = var.image_id
  instance_type         = var.ecs_instance_type
  login_mode            = var.ecs_login_mode
  key_pair_name         = var.key_pair_name
  password              = var.ecs_password
  system_volume_type    = var.ecs_system_volume_type
  system_volume_size_gb = var.ecs_system_volume_size_gb
  eip_bandwidth_mbps    = var.eip_bandwidth_mbps
  wordpress_version     = var.wordpress_version
  wordpress_sha256      = var.wordpress_sha256
  database_host         = module.database.private_host
  database_port         = module.database.private_port
  database_name         = module.database.database_name
  database_username     = module.database.account_name
  database_password     = var.database_password
  project_name          = var.cloud_project_name
  tags                  = local.common_tags

  depends_on = [time_sleep.before_security_group_destroy]
}
