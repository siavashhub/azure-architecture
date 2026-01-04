# +++++++++++++++++++++++++++++++++++++++++++++++ #
#           AI Service Outputs Resource           #
#                                                 #

output "name" {
  description = "The name of ai service created."
  value       = azurerm_ai_services.ai.name
}

output "resource_id" {
  description = "The resource ID of ai service created."
  value       = azurerm_ai_services.ai.id
}

output "endpoint" {
  description = "The endpoint used to connect to the AI Service Account."
  value       = azurerm_ai_services.ai.endpoint
}

#                                                 #
#         END AI Service Outputs Resource         #
# +++++++++++++++++++++++++++++++++++++++++++++++ #
