output "server_ips" {
  description = "Dynamically assigned IPv4 addresses for all KijaniKiosk servers."
  value = {
    for role, server in module.app_server :
    role => server.ipv4
  }
}

output "api_ip" {
  description = "IPv4 address of the KijaniKiosk API server."
  value       = module.app_server["api"].ipv4
}

output "payments_ip" {
  description = "IPv4 address of the KijaniKiosk payments server."
  value       = module.app_server["payments"].ipv4
}

output "logs_ip" {
  description = "IPv4 address of the KijaniKiosk logs server."
  value       = module.app_server["logs"].ipv4
}

output "ssh_commands" {
  description = "SSH commands for connecting to each server."
  value = {
    for role, server in module.app_server :
    role => "ssh ubuntu@${server.ipv4}"
  }
}
