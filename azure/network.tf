# create NETOWRK in azure
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = [var.vpc.cidr_block_range]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# create two public subnet
resource "azurerm_subnet" "private_a" {
  name                 = "private_a"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.vpc.subnet_private_a_cidr_block_range]
}

resource "azurerm_subnet" "private_b" {
  name                 = "private_b"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.vpc.subnet_private_b_cidr_block_range]
}
