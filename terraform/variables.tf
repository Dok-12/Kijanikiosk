variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "lab"
}

variable "region" {
  description = "Logical deployment region."
  type        = string
  default     = "local"
}

variable "ssh_key" {
  description = "SSH public key associated with the lab infrastructure."
  type        = string
  default     = ""
  sensitive   = true
}

variable "image" {
  description = "Ubuntu image used for all KijaniKiosk servers."
  type        = string
  default     = "24.04"
}

variable "instance_type" {
  description = "Default resource sizing for KijaniKiosk servers."
  type = object({
    cpus   = number
    memory = string
    disk   = string
  })

  default = {
    cpus   = 1
    memory = "1G"
    disk   = "5G"
  }
}
