output "name" {
  description = "Name of the Multipass instance."
  value       = multipass_instance.this.name
}

output "ipv4" {
  description = "Dynamically assigned IPv4 address of the instance."
  value       = multipass_instance.this.ipv4
}
