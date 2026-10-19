region  = "cn-beijing"
zone_id = "cn-beijing-a"

project_name       = "wordpress"
environment        = "demo"
owner              = "platform-team"
cost_center        = "shared"
cloud_project_name = "default"

vpc_cidr    = "10.20.0.0/16"
subnet_cidr = "10.20.1.0/24"
# Temporary development setting. Replace with an approved management CIDR
# before publishing or deploying a persistent environment.
admin_cidr = "0.0.0.0/0"

# Replace these values with resources and specifications available in the
# selected region and availability zone.
image_id = "image-ydf193g9cqb6uoeqqqj8"

# ECS login credentials are mutually exclusive.
# Key-pair mode:
# ecs_login_mode = "key_pair"
# key_pair_name  = "REPLACE_WITH_EXISTING_KEY_PAIR_NAME"
# ecs_password   = null
# The published one-command configuration uses password mode:
ecs_login_mode = "password"
ecs_password   = "ReplaceWithStrongPassword123"

ecs_instance_type  = "ecs.g4i.large"
eip_bandwidth_mbps = 5
rds_node_spec      = "rds.mysql.c.s.1c2g"
database_username  = "wordpress_app"

# Rotate this deployment password before sharing or production use.
database_password = "ReplaceWithStrongPassword123"

additional_tags = {
  Purpose = "WordPressDemo"
}
