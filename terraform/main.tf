terraform {
  required_version = ">= 1.6.0"

  required_providers {
    multipass = {
      source  = "larstobi/multipass"
      version = "~> 1.0"
    }
  }
}

locals {
  servers = {
    api = {
      name = "kijanikiosk-api"
    }

    payments = {
      name = "kijanikiosk-payments"
    }

    logs = {
      name = "kijanikiosk-logs"
    }
  }
}

module "app_server" {
  for_each = local.servers

  source = "./modules/app_server"

  name           = each.value.name
  image          = var.image
  cpus           = var.instance_type.cpus
  memory         = var.instance_type.memory
  disk           = var.instance_type.disk
  cloudinit_file = "${path.module}/cloud-init/user-data.yaml"
}
