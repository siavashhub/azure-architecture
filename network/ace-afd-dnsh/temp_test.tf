# resource "azurerm_resource_group" "remote" {
#   name     = "rg-${var.prefix}-${var.workload}-remote-${var.environment_type}-${var.region}-001"
#   location = var.location

#   tags = {
#     "Created By"  = "siyo@softchoice.com"
#     "Environment" = var.environment_type
#     "Workload"    = var.workload
#   }
# }

# resource "azurerm_subnet" "bastion" {
#   name                 = "AzureBastionSubnet"
#   virtual_network_name = azurerm_virtual_network.ace_1.name
#   resource_group_name  = azurerm_resource_group.network.name

#   address_prefixes = ["10.100.11.224/27"]
# }

# resource "azurerm_subnet" "workload" {
#   name                 = "workload"
#   virtual_network_name = azurerm_virtual_network.ace_1.name
#   resource_group_name  = azurerm_resource_group.network.name

#   address_prefixes = ["10.100.11.192/27"]
# }


# ###### azure bastion #####
# resource "azurerm_public_ip" "bastion" {
#   name                = "pip-bastion-${var.workload}-${var.environment_type}-${var.region}-001"
#   location            = azurerm_resource_group.remote.location
#   resource_group_name = azurerm_resource_group.remote.name
#   allocation_method   = "Static"
#   sku                 = "Standard"

#   lifecycle {
#     ignore_changes = [tags]
#   }
# }

# resource "azurerm_bastion_host" "hub_primary" {
#   name                = "bas-${var.workload}-${var.environment_type}-${var.region}-001"
#   location            = azurerm_resource_group.remote.location
#   resource_group_name = azurerm_resource_group.remote.name

#   ip_configuration {
#     name                 = "configuration"
#     subnet_id            = azurerm_subnet.bastion.id
#     public_ip_address_id = azurerm_public_ip.bastion.id
#   }

#   lifecycle {
#     ignore_changes = [tags]
#   }
# }


# ##### jump box 

# resource "azurerm_network_interface" "jump_box" {
#   name                = "nic-${var.workload}-jb-${var.environment_type}-${var.region}-001"
#   location            = azurerm_resource_group.remote.location
#   resource_group_name = azurerm_resource_group.remote.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.workload.id
#     private_ip_address_allocation = "Dynamic"
#   }

#   lifecycle {
#     ignore_changes = [tags]
#   }
# }

# resource "azurerm_windows_virtual_machine" "jump_box" {
#   name                = "jb-01"
#   resource_group_name = azurerm_resource_group.remote.name
#   location            = azurerm_resource_group.remote.location
#   size                = "Standard_B2s"
#   admin_username      = "testadmin"
#   admin_password      = "P@ssw0rd123!"
#   network_interface_ids = [
#     azurerm_network_interface.jump_box.id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2022-Datacenter"
#     version   = "latest"
#   }

#   lifecycle {
#     ignore_changes = [tags]
#   }
# }