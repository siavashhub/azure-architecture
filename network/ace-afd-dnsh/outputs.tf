output "public_dns_zone_name_servers" {
  description = "Name servers for the custom public DNS zone, to be used to create NS records in parent zone"
  value = azurerm_dns_zone.custom.name_servers
}
output "app1_test_url" {
  description = "App1 Container App Test Url"
  value       = "https://${local.app1_service_name}.${var.custom_domain_zone_name}/ping"
}

output "app2_test_url" {
  description = "App2 Container App Test Url"
  value       = "https://${local.app2_service_name}.${var.custom_domain_zone_name}/ping"
}
