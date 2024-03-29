terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9.14"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.4.0"
    }
  }
  required_version = ">= 1.0"
}