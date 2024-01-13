
variable "proxmox_host" {
  type    = string
  default = "10.10.10.8"
}

variable "proxmox_username" {
  type    = string
  default = "packer@pve!packer"
}

variable "proxmox_token" {
  type    = string
  default = "3e3d7cf0-7c23-44a9-9dcb-3c180be62d40"
}

variable "proxmox_nodename" {
  type    = string
  default = "pve-hulk"
}

variable "proxmox_storage" {
  type    = string
  default = "local-lvm"
}

variable "proxmox_storage_type" {
  type    = string
  default = "local-lvm"
}

variable "talos_version" {
  type    = string
  default = "v1.6.0"
}

variable "talos_image_schematic_id" {
  type = string
  default = "f5ed184cadfec549abe8e91d13d7517b83480ea2ec39ae280efef66514badbe3"
}

locals {
  image = "https://factory.talos.dev/image/${var.talos_image_schematic_id}/${var.talos_version}/nocloud-amd64.raw.xz"
}