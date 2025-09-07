variable "admin_username" {
  description = "Username for Linux VM"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Password for Linux VM"
  type        = string
  sensitive   = true
}

variable "vm_name" {
  description = "Linux VM name"
  type        = string
  default = "linux-vm"
}

variable "resource_group_name" {
  description = "Azure Resource Group name"
  type        = string
  default = "rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "Virtual Network Name"
  type = string
  default = "vnet"
}

variable "subnet_name" {
  description = "Subnet name"
  type = string
  default = "public_subnet"
}