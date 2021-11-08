provider "azurerm" {
  features {}
  subscription_id           = var.azure_subscription_id
  client_id                 = var.azure_client_id
  client_secret             = var.azure_client_secret
  tenant_id                 = var.azure_tenant_id
}

resource "azurerm_resource_group" "windows" {
  name                      = var.azure_resource_group_name
  location                  = var.azure_location
}

resource "azurerm_shared_image_gallery" "windows" {
  name                      = var.azure_shared_image_gallery_name
  resource_group_name       = azurerm_resource_group.windows.name
  location                  = azurerm_resource_group.windows.location
  description               = var.azure_shared_image_gallery_description

  tags = var.azure_tags
}

resource "azurerm_shared_image" "windows" {
  name                      = var.azure_managed_image_name
  gallery_name              = azurerm_shared_image_gallery.windows.name
  resource_group_name       = azurerm_resource_group.windows.name
  location                  = azurerm_resource_group.windows.location
  os_type                   = var.azure_os_type

  identifier {
    publisher               = var.azure_managed_image_publisher
    offer                   = var.azure_managed_image_offer
    sku                     = var.azure_managed_image_sku
  }

  hyper_v_generation        = var.azure_managed_image_hyper_v_generation
  tags                      = var.azure_tags
}
