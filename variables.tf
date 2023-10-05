variable "sp_subscription_id" {}
variable "sp_client_id" {}
variable "sp_client_secret" {}
variable "sp_tenant_id" {}
variable "principal_id" {}

# Replace "YOUR_LAPTOP_PUBLIC_IP" with your actual public IP address
variable "myip" {
  default = "73.254.158.216/32"
}
variable "f5_username" {
  description = "The admin username of the F5 Bigip that will be deployed"
  default     = "bigipuser"
}

variable "f5_password" {
  description = "The admin password of the F5 Bigip that will be deployed"
  default     = ""
}

variable "vm_name" {
  description = "Name of F5 BIGIP VM to be used,it should be unique `name`,default is empty string meaning module adds with prefix + random_id"
  default     = ""
}

variable "f5_instance_type" {
  description = "Specifies the size of the virtual machine."
  type        = string
  default     = "Standard_D8s_v4"
}

variable "os_disk_size" {
  description = "The size of the Data Disk which should be created"
  type        = number
  default     = 84
}

variable "image_publisher" {
  description = "Specifies product image publisher"
  type        = string
  default     = "f5-networks"
}

variable "f5_image_name" {
  type        = string
  default     = "f5-big-best-plus-hourly-25mbps"
  description = <<-EOD
After finding the image to use with the Azure CLI with a variant of the following;

az vm image list --publisher f5-networks --all -f better

{
    "offer": "f5-big-ip-better",
    "publisher": "f5-networks",
    "sku": "f5-bigip-virtual-edition-25m-better-hourly",
    "urn": "f5-networks:f5-big-ip-better:f5-bigip-virtual-edition-25m-better-hourly:14.1.404001",
    "version": "14.1.404001"
}

f5_image_name is equivalent to the "sku" returned.
EOD  
}
variable "f5_version" {
  type        = string
  default     = "latest"
  description = <<-EOD
After finding the image to use with the Azure CLI with a variant of the following;

az vm image list --publisher f5-networks --all -f better

{
    "offer": "f5-big-ip-better",
    "publisher": "f5-networks",
    "sku": "f5-bigip-virtual-edition-25m-better-hourly",
    "urn": "f5-networks:f5-big-ip-better:f5-bigip-virtual-edition-25m-better-hourly:14.1.404001",
    "version": "14.1.404001"
}

f5_version is equivalent to the "version" returned.
EOD  
}

variable "f5_product_name" {
  type        = string
  default     = "f5-big-ip-best"
  description = <<-EOD
After finding the image to use with the Azure CLI with a variant of the following;

az vm image list --publisher f5-networks --all -f better

{
    "offer": "f5-big-ip-better",
    "publisher": "f5-networks",
    "sku": "f5-bigip-virtual-edition-25m-better-hourly",
    "urn": "f5-networks:f5-big-ip-better:f5-bigip-virtual-edition-25m-better-hourly:14.1.404001",
    "version": "14.1.404001"
}

f5_product_name is equivalent to the "offer" returned.
EOD  
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  default     = "Standard_LRS"
}

variable "enable_accelerated_networking" {
  type        = bool
  description = "(Optional) Enable accelerated networking on Network interface"
  default     = false
}
