# This module provisions one public ECS instance and installs WordPress.
# Database credentials are embedded in user data and therefore Terraform state.

locals {
  bootstrap_script = templatefile("${path.module}/templates/wordpress-bootstrap.sh.tftpl", {
    wordpress_version        = var.wordpress_version
    wordpress_sha256         = var.wordpress_sha256
    database_host            = var.database_host
    database_port            = var.database_port
    database_name            = var.database_name
    database_username        = var.database_username
    database_password_base64 = base64encode(var.database_password)
  })
}

resource "volcenginecc_ecs_instance" "wordpress" {
  instance_name             = "${var.resource_prefix}-web"
  hostname                  = "${var.resource_prefix}-web"
  description               = "Nginx and PHP runtime for the WordPress demonstration"
  instance_type             = var.instance_type
  instance_charge_type      = "PostPaid"
  spot_strategy             = "NoSpot"
  zone_id                   = var.zone_id
  project_name              = var.project_name
  deletion_protection       = false
  install_run_command_agent = false

  image = {
    image_id              = var.image_id
    keep_image_credential = false
  }

  password = var.login_mode == "password" ? var.password : null

  key_pair = var.login_mode == "key_pair" ? {
    key_pair_name = var.key_pair_name
  } : null

  primary_network_interface = {
    subnet_id           = var.subnet_id
    vpc_id              = var.vpc_id
    security_group_ids  = [var.security_group_id]
    ipv_6_address_count = 0
  }

  system_volume = {
    volume_type          = var.system_volume_type
    size                 = var.system_volume_size_gb
    delete_with_instance = true
  }

  eip_address = {
    charge_type           = "PayByTraffic"
    bandwidth_mbps        = var.eip_bandwidth_mbps
    isp                   = "BGP"
    release_with_instance = true
    bandwidth_package_id  = ""
  }

  user_data = base64encode(replace(local.bootstrap_script, "\r\n", "\n"))

  tags = [
    for key, value in var.tags : {
      key   = key
      value = value
    }
  ]

  lifecycle {
    precondition {
      condition = (
        (
          var.login_mode == "key_pair" &&
          var.key_pair_name != null &&
          nonsensitive(var.password == null)
        ) ||
        (
          var.login_mode == "password" &&
          var.key_pair_name == null &&
          nonsensitive(var.password != null)
        )
      )
      error_message = "ECS credentials are mutually exclusive: key_pair mode requires key_pair_name and no password; password mode requires password and no key_pair_name."
    }
  }
}
