# Azure Shared
variable "azure_subscription_id" {
    # override in terraform.tfvars
    type = string
    default = ""
    description = "Azure Subscription ID. In Azure Portal click Cost Management + Billing. Here you find your asigned Subscription ID"
}
variable "azure_client_id" {
    # override in terraform.tfvars
    type = string
    default = ""
    description = "Azure Client ID. This is the Application ID of the registered App in Azure Portal"
}
variable "azure_client_secret" {
    # override in terraform.tfvars
    type = string
    default = ""
    description = "Azure Client Secret. This is the key's password value of the registered App in the Azure Portal"
}
variable "azure_tenant_id" {
    # override in terraform.tfvars
    type = string
    default = ""
    description = "Azure Tenant ID. In Azure Portal click Azure Active Directory -> Properties an note th Directory ID"
}
variable "azure_location" {
    type = string
    default = ""
}
variable "azure_resource_group_name" {
    type = string
    default = ""
    description = ""
}

variable "azure_shared_image_gallery_name" {
    type = string
    default = ""
}

variable "azure_shared_image_gallery_description" {
    type = string
    default = "Share Image Gallery for automatic packer builds"
}

variable "azure_managed_image_name" {
    type = string
    default = ""
}

variable "azure_managed_image_publisher" {
    type = string
    default = ""
}

variable "azure_managed_image_offer" {
    type = string
    default = ""
}

variable "azure_managed_image_sku" {
    type = string
    default = ""
}

variable "azure_managed_image_hyper_v_generation" {
    type = string
    default = "V1"
    description = "The generation of HyperV that the Virtual Machine used to create the Shared Image is based on. Possible values are V1 and V2. Defaults to V1. Changing this forces a new resource to be created."
}

variable "azure_os_type" {
    type = string
    default = "Windows"
}

variable "azure_tags" {
  type        = map(string)
  description = "(map[string]string) - Name/value pair tags to apply to every resource deployed i.e. Resource Group, VM, NIC, VNET, Public IP, KeyVault, etc. The user can define up to 15 tags. Tag names cannot exceed 512 characters, and tag values cannot exceed 256 characters."

  default = {
    source = "packer"
  }  
}
