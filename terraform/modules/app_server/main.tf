resource "multipass_instance" "this" {
  name           = var.name
  image          = var.image
  cpus           = var.cpus
  memory         = var.memory
  disk           = var.disk
  cloudinit_file = var.cloudinit_file
}
