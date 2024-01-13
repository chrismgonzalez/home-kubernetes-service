variable "proxmox_username" {
  type = string
}

variable "proxmox_token" {
  type = string
}

variable "proxmox_url" {
  type = string
}

variable "proxmox_nodename" {
  type = string
}

variable "proxmox_storage" {
  type = string
}

variable "proxmox_storage_type" {
  type = string
}

variable "static_ip" {
  type = string
}

variable "gateway" {
  type = string
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

variable "harbor_version" {
  type = string
  default = "v2.10.0"
}