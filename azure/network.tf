# create NETOWRK in azure
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  address_space       = [var.vpc.cidr_block_range]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    Application = var.default_tags["Application"]
    Environment = var.default_tags["Environment"]
    Owner       = var.default_tags["Owner"]
    CostCenter  = var.default_tags["CostCenter"]
    Provider    = var.default_tags["Provider"]
    Schedule    = var.default_tags["Schedule"]
    AzBackup    = var.default_tags["AzBackup"]
    PatchGroup  = var.default_tags["PatchGroup"]
  }
}

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

resource "azurerm_network_interface" "private_a_nic" {
  name                = "${azurerm_subnet.private_a.name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private_a.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface" "private_b_nic" {
  name                = "${azurerm_subnet.private_b.name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private_b.id
    private_ip_address_allocation = "Dynamic"
  }
}

#public ip in azure
resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}
