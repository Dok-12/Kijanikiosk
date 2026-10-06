variable "name" {
  description = "Name of the Multipass instance."
  type        = string
}

variable "image" {
  description = "Ubuntu image or release to use."
  type        = string
  default     = "24.04"
}

variable "cpus" {
  description = "Number of CPUs allocated to the instance."
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory allocated to the instance."
  type        = string
  default     = "1G"
}

variable "disk" {
  description = "Disk allocated to the instance."
  type        = string
  default     = "5G"
}

variable "cloudinit_file" {
  description = "Path to the cloud-init configuration file."
  type        = string
}
